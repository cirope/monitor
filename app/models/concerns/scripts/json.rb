module Scripts::JSON
  extend ActiveSupport::Concern

  JSON_EXCLUDED_ATTRIBUTES   = [:id, :file, :lock_version, :imported_at]
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
    }
  }
  JSON_DEFAULT_OPTIONS = {
    except:  JSON_EXCLUDED_ATTRIBUTES,
    include: JSON_INCLUDED_ASSOCIATIONS
  }

  def as_json options = {}
    super JSON_DEFAULT_OPTIONS.merge(options)
  end
end
