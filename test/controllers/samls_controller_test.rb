# frozen_string_literal: true

require 'test_helper'

class SamlsControllerTest < ActionController::TestCase

  setup do
    @saml = samls :saml_config

    login user: users(:god)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create saml' do
    assert_difference 'Saml.count' do
      post :create, params: {
        saml: {
          provider: 'azure',
          idp_homepage: 'idp_homepage',
          idp_entity_id: 'idp_entity_id',
          idp_sso_target_url: 'idp_sso_target_url',
          sp_entity_id: 'sp_entity_id',
          assertion_consumer_service_url: 'assertion_consumer_service_url',
          name_identifier_format: 'name_identifier_format',
          assertion_consumer_service_binding: 'assertion_consumer_service_binding',
          idp_cert: 'idp_cert',
          username_attribute: 'name',
          name_attribute: 'givenname',
          lastname_attribute: 'surname',
          email_attribute: 'emailaddress',
          roles_attribute: 'description',
          role_guest: 'Guest',
          role_author: 'Author',
          role_supervisor: 'Supervisor',
          role_security: 'Security'
        }
      }
    end

    assert_redirected_to saml_url(Saml.last)
  end

  test 'should show saml' do
    get :show, params: { id: @saml }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @saml }
    assert_response :success
  end

  test 'should update saml' do
    patch :update, params: {
      id: @saml,
      saml: { idp_homepage: 'updated' }
    }

    assert_redirected_to saml_url(@saml)
  end

  test 'should destroy saml' do
    assert_difference 'Saml.count', -1 do
      delete :destroy, params: { id: @saml }
    end

    assert_redirected_to samls_url
  end
end
