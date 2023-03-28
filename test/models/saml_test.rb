# frozen_string_literal: true

require 'test_helper'

class SamlTest < ActiveSupport::TestCase
  setup do
    @saml = samls :saml_config
  end

  teardown do
    Current.account = nil
  end

  test 'validates presence' do
    @saml.idp_homepage = ''
    @saml.idp_entity_id = ''
    @saml.idp_sso_target_url = ''
    @saml.sp_entity_id = ''
    @saml.assertion_consumer_service_url = ''
    @saml.name_identifier_format = ''
    @saml.assertion_consumer_service_binding = ''
    @saml.idp_cert = ''
    @saml.username_attribute = ''
    @saml.name_attribute = ''
    @saml.lastname_attribute = ''
    @saml.email_attribute = ''
    @saml.roles_attribute = ''

    assert @saml.invalid?
    assert_error @saml, :idp_homepage, :blank
    assert_error @saml, :idp_entity_id, :blank
    assert_error @saml, :idp_sso_target_url, :blank
    assert_error @saml, :sp_entity_id, :blank
    assert_error @saml, :assertion_consumer_service_url, :blank
    assert_error @saml, :name_identifier_format, :blank
    assert_error @saml, :assertion_consumer_service_binding, :blank
    assert_error @saml, :idp_cert, :blank
    assert_error @saml, :username_attribute, :blank
    assert_error @saml, :name_attribute, :blank
    assert_error @saml, :lastname_attribute, :blank
    assert_error @saml, :email_attribute, :blank
    assert_error @saml, :roles_attribute, :blank
  end

  test 'validates inclusion' do
    @saml.provider = 'wrong'

    assert @saml.invalid?
    assert_error @saml, :provider, :inclusion
  end

  test 'validates formats' do
    @saml.username_attribute = '?'
    @saml.name_attribute = '?'
    @saml.lastname_attribute = '?'
    @saml.email_attribute = '?'

    assert @saml.invalid?
    assert_error @saml, :username_attribute, :invalid
    assert_error @saml, :name_attribute, :invalid
    assert_error @saml, :lastname_attribute, :invalid
    assert_error @saml, :email_attribute, :invalid
  end

  test 'default' do
    assert_not_nil Saml.default
  end
end
