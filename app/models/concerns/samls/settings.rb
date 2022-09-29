module Samls::Settings
  extend ActiveSupport::Concern

  def settings
    {
      idp_homepage:                       idp_homepage,
      idp_entity_id:                      idp_entity_id,
      idp_sso_target_url:                 idp_sso_target_url,
      sp_entity_id:                       sp_entity_id,
      assertion_consumer_service_url:     assertion_consumer_service_url,
      name_identifier_format:             name_identifier_format,
      assertion_consumer_service_binding: assertion_consumer_service_binding,
      idp_cert:                           idp_cert
    }
  end
end
