# frozen_string_literal: true

module Scripts::Json
  extend ActiveSupport::Concern

  # TODO: remove :file after migration to ActiveStorage
  JSON_EXCLUDED_ATTRIBUTES   = [:id, :file, :lock_version, :imported_at, :import_type]
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
    methods: [:current_version, :select_import_type]
  }

  def select_import_type
    tags_selected = tags.select do |tag|
      tag['options']['export_edit'] ==  true
    end

    tags_selected.size > 0 ? Tag::EXPORT_OPTIONS[:edit] : Tag::EXPORT_OPTIONS[:read]
  end

  def as_json options = {}
    super JSON_DEFAULT_OPTIONS.merge(options)
  end
end
