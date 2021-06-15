# frozen_string_literal: true

module Scripts::Import
  extend ActiveSupport::Concern

  module ClassMethods
    def import zip_path
      transaction do
        exceptions = {}
        import_zip zip_path, exceptions
        raise ActiveRecord::ActiveRecordError, (list_of_exceptions exceptions) if exceptions.present?
      end
    end

    private

      def list_of_exceptions exceptions
        ret = 'Se produjo un error importando los guiones, revise los siguientes:<ul>'
        exceptions.each {|key, value| ret = ret + ("<li>#{key}: #{value}</li>")  }
        (ret + "</ul>").html_safe
      end

      def import_zip zip_path, exceptions
        scripts_data = {}
        
        Zip::File.open zip_path do |zipfile|
          zipfile.each do |entry|
            script_data = ActiveSupport::JSON.decode entry.get_input_stream.read

            scripts_data[script_data['uuid']] = script_data
          end
        end

        import_scripts scripts_data, exceptions
      end


      def import_scripts scripts_data, exceptions
        scripts_data.each do |uuid, script_data|
          begin
            import_script script_data, scripts_data  
          rescue => exception
            exceptions[uuid] = exception.message
          end
        end  
      end

      def import_script data, scripts_data
        return if data == :imported

        uuid   = data['uuid']
        script = find_by uuid: uuid

        import_requires data['requires'], scripts_data

        if script
          script.update_from_data data
        else
          create_from_data data
        end

        scripts_data[uuid] = :imported
      end

      def import_requires requires, scripts_data
        requires.each do |require|
          script_uuid = require['script']['uuid']

          import_script scripts_data[script_uuid], scripts_data
        end
      end

      def create_from_data data
        parameters = data.delete('parameters')
        requires   = require_attributes data.delete('requires')

        if data['change'].blank?
          date           = I18n.l Time.zone.now, format: :compact
          data['change'] = I18n.t 'scripts.imports.default_change', date: date
        end

        create! data.merge({
          imported_at:           Time.zone.now,
          parameters_attributes: parameters,
          requires_attributes:   requires
        })
      end

      def require_attributes requires_data
        uuids = requires_data.map { |require_data| require_data['script']['uuid'] }

        Script.where(uuid: uuids).map { |script| { script_id: script.id } }
      end
  end

  def update_from_data data
    update_parameters data.delete('parameters')
    update_requires   data.delete('requires')

    data['imported_at'] = Time.zone.now if imported_at

    update! data
  end

  private

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

    def update_requires requires_data
      uuids = requires_data.map { |require_data| require_data['script']['uuid'] }

      self.class.where(uuid: uuids).each do |script|
        require = requires.detect { |r| r.script_id == script.id }

        requires.create! script_id: script.id unless require
      end

      requires.by_uuid(uuids).destroy_all
    end
end
