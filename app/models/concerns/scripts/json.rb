# frozen_string_literal: true

module Scripts::Json
  extend ActiveSupport::Concern
  included do
    enum export_options: {
      edit: 'edit',
      read: 'read'
    }
  end

  # TODO: remove :file after migration to ActiveStorage
  JSON_EXCLUDED_ATTRIBUTES   = [:id, :file, :lock_version, :imported_at, :imported_as]
  JSON_INCLUDED_ASSOCIATIONS = {
    requires: {
      only: [],
      include: {
        script: {
          only: :uuid
        }
      }
    },
    parameters: {
      only: [:name, :value]
    },
    descriptions: {
      only: [:name, :value]
    }
  }
  JSON_DEFAULT_OPTIONS = {
    except:  JSON_EXCLUDED_ATTRIBUTES,
    include: JSON_INCLUDED_ASSOCIATIONS,
    methods: [:current_version, :exported_as]
  }

  def exported_as
    export_as_editable = tags.detect &:editable?

    export_as_editable.present? ? Script::export_options[:edit] : Script::export_options[:read]
  end

  def as_json options = {}
    super JSON_DEFAULT_OPTIONS.merge(options)
  end
end
