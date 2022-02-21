# frozen_string_literal: true

module Scripts::Json
  extend ActiveSupport::Concern

  EXPORT_OPTIONS = {
    edit: 'edit',
    read: 'read'
  }
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
    methods: [:current_version, :select_imported_as]
  }

  def select_imported_as
    tags_selected = tags.detect(&:editable)

    tags_selected.present? ? EXPORT_OPTIONS[:edit] : EXPORT_OPTIONS[:read]
  end

  def as_json options = {}
    super JSON_DEFAULT_OPTIONS.merge(options)
  end
end
