# frozen_string_literal: true

module Scripts::Import
  extend ActiveSupport::Concern

  attr_accessor :imported_status

  module ClassMethods
    def import zip_path
      scripts = []

      transaction do
        scripts = import_zip zip_path

        raise ActiveRecord::Rollback if scripts.any? &:invalid?
      end

      scripts
    end

    def file_invalid? file_path
      extension = file_path.split('.').last.downcase

      extension.blank? || extension != 'zip'
    end

    private

      def import_zip zip_path
        scripts_data = {}

        Zip::File.open zip_path do |zipfile|
          zipfile.each do |entry|
            script_data = ActiveSupport::JSON.decode entry.get_input_stream.read

            scripts_data[script_data['uuid']] = script_data
          end
        end

        import_scripts scripts_data
      end

      def import_scripts scripts_data
        scripts_data.map do |_uuid, script_data|
          import_script script_data, scripts_data
        end.compact
      end

      def import_script data, scripts_data
        return if data == :imported

        uuid    = data['uuid']
        script  = find_by uuid: uuid
        version = data.delete 'current_version'

        import_requires data['requires'], scripts_data

        if script
          script.update_from_data data
          script.imported_status = :updated
        else
          script = create_from_data data
          script.imported_status = :created
        end

        script.imported_version = version || script.default_version

        scripts_data[uuid] = :imported if script.valid?

        script
      end

      def import_requires requires, scripts_data
        requires.each do |require|
          script_uuid = require['script']['uuid']

          import_script scripts_data[script_uuid], scripts_data
        end
      end

      def create_from_data data
        descriptions = data.delete('descriptions') || []
        imported_as  = data.delete('exported_as') || default_imported_as
        parameters   = data.delete('parameters')
        requires     = require_attributes data.delete('requires')

        if data['change'].blank?
          date           = I18n.l Time.zone.now, format: :compact
          data['change'] = I18n.t 'scripts.imports.default_change', date: date
        end

        create data.merge({
          descriptions_attributes: descriptions,
          imported_as:             imported_as,
          imported_at:             Time.zone.now,
          parameters_attributes:   parameters,
          requires_attributes:     requires
        })
      end

      def require_attributes requires_data
        uuids = requires_data.map { |require_data| require_data['script']['uuid'] }

        Script.where(uuid: uuids).map { |script| { script_id: script.id } }
      end
  end

  def update_from_data data
    update_descriptions data.delete('descriptions') || []
    update_parameters   data.delete('parameters')
    update_requires     data.delete('requires')

    data['imported_as'] = data.delete('exported_as') || default_imported_as
    data['imported_at'] = Time.zone.now if imported_at

    update data
  end

  private

    def default_imported_as
      Script.imported_as[:read_only]
    end

    def update_parameters parameters_data
      names = []

      parameters_data.each do |parameter_data|
        name      = parameter_data['name']
        parameter = parameters.detect { |p| p.name == name }

        parameters.create! parameter_data unless parameter

        names << name
      end

      parameters.where.not(name: names).destroy_all
    end

    def update_descriptions descriptions_data
      names = []

      descriptions_data.each do |description_data|
        name        = description_data['name']
        description = descriptions.detect { |d| d.name == name }

        descriptions.create! description_data unless description

        names << name
      end

      descriptions.where.not(name: names).destroy_all
    end

    def update_requires requires_data
      uuids = requires_data.map { |require_data| require_data['script']['uuid'] }

      self.class.where(uuid: uuids).each do |script|
        require = requires.detect { |r| r.script_id == script.id }

        requires.create! script_id: script.id unless require
      end

      requires.by_uuid(uuids).destroy_all
    end
end
