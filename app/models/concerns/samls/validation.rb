module Samls::Validation
  extend ActiveSupport::Concern

  included do
    PROVIDERS = %w(azure)

    validates :provider, inclusion: { in: PROVIDERS }
    validates :idp_homepage, :idp_entity_id, :idp_sso_target_url,
      :sp_entity_id, :assertion_consumer_service_url, :name_identifier_format,
      :assertion_consumer_service_binding, :idp_cert, :username_attribute,
      :name_attribute, :lastname_attribute, :email_attribute, :roles_attribute,
      presence: true
    validates :idp_homepage, :idp_entity_id, :idp_sso_target_url,
      :sp_entity_id, :assertion_consumer_service_url, :name_identifier_format,
      :assertion_consumer_service_binding, :username_attribute,
      :name_attribute, :lastname_attribute, :email_attribute, :roles_attribute,
      length: { maximum: 255 }
    validates :username_attribute, :name_attribute, :lastname_attribute,
      :email_attribute, format: /\A\w+\z/, allow_blank: true
  end
end
