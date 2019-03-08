module Rules::Json
  extend ActiveSupport::Concern

  JSON_EXCLUDED_ATTRIBUTES   = [:id, :lock_version, :imported_at]
  JSON_INCLUDED_ASSOCIATIONS = {
    triggers: {
      only: [:uuid, :callback]
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
