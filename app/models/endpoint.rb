class Endpoint < ApplicationRecord
  include Attributes::Strip
  include Endpoints::DynamicsProcess
  include Endpoints::DynamicsOptions
  include Endpoints::I18nHelpers
  include Endpoints::Process
  include Endpoints::Providers
  include Endpoints::Scopes
  include Endpoints::Validation
  include PublicAuditable

  strip_fields :name

  def to_s
    name
  end
end
