# frozen_string_literal: true

class Saml < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Samls::Options
  include Samls::Providers
  include Samls::Settings
  include Samls::Validation

  strip_fields :idp_homepage, :idp_entity_id, :idp_sso_target_url,
    :sp_entity_id, :assertion_consumer_service_url, :name_identifier_format,
    :assertion_consumer_service_binding, :idp_cert, :username_attribute,
    :name_attribute, :lastname_attribute, :email_attribute

  def self.default
    order(:id).first
  end

  def to_s
    provider
  end
end
