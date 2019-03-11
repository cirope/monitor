# frozen_string_literal: true

module Rules::Import
  extend ActiveSupport::Concern

  module ClassMethods
    def import zip_path
      transaction { import_zip zip_path }
    end

    private

      def import_zip zip_path
        Zip::File.open zip_path do |zipfile|
          zipfile.each do |entry|
            rule_data = ActiveSupport::JSON.decode entry.get_input_stream.read

            import_rule rule_data
          end
        end
      end

      def import_rule data
        uuid = data['uuid']
        rule = find_by uuid: uuid

        if rule
          rule.update_from_data data
        else
          create_from_data data
        end
      end

      def create_from_data data
        triggers = data.delete('triggers')

        create! data.merge(
          imported_at:         Time.zone.now,
          triggers_attributes: triggers
        )
      end
  end

  def update_from_data data
    update_triggers data.delete('triggers')

    data['imported_at'] = Time.zone.now if imported_at

    update! data
  end

  private

    def update_triggers triggers_data
      uuids = []

      triggers_data.each do |trigger_data|
        uuid    = trigger_data['uuid']
        trigger = triggers.detect { |p| p.uuid == uuid }

        if trigger
          trigger.update! trigger_data
        else
          triggers.create! trigger_data
        end

        uuids << uuid
      end

      triggers.where.not(uuid: uuids).destroy_all
    end
end
