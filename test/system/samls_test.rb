require "application_system_test_case"

class SamlsTest < ApplicationSystemTestCase
  setup do
    @saml = samls(:one)
  end

  test "visiting the index" do
    visit samls_url
    assert_selector "h1", text: "Samls"
  end

  test "creating a Saml" do
    visit samls_url
    click_on "New Saml"

    fill_in "Assertion consumer service binding", with: @saml.assertion_consumer_service_binding
    fill_in "Assertion consumer service url", with: @saml.assertion_consumer_service_url
    fill_in "Email attribute", with: @saml.email_attribute
    fill_in "Idp cert", with: @saml.idp_cert
    fill_in "Idp entity", with: @saml.idp_entity_id
    fill_in "Idp homepage", with: @saml.idp_homepage
    fill_in "Idp sso target url", with: @saml.idp_sso_target_url
    fill_in "Lastname attribute", with: @saml.lastname_attribute
    fill_in "Lock version", with: @saml.lock_version
    fill_in "Name attribute", with: @saml.name_attribute
    fill_in "Name identifier format", with: @saml.name_identifier_format
    fill_in "Provider", with: @saml.provider
    fill_in "Roles attribute", with: @saml.roles_attribute
    fill_in "Sp entity", with: @saml.sp_entity_id
    fill_in "Username attribute", with: @saml.username_attribute
    click_on "Create Saml"

    assert_text "Saml was successfully created"
    click_on "Back"
  end

  test "updating a Saml" do
    visit samls_url
    click_on "Edit", match: :first

    fill_in "Assertion consumer service binding", with: @saml.assertion_consumer_service_binding
    fill_in "Assertion consumer service url", with: @saml.assertion_consumer_service_url
    fill_in "Email attribute", with: @saml.email_attribute
    fill_in "Idp cert", with: @saml.idp_cert
    fill_in "Idp entity", with: @saml.idp_entity_id
    fill_in "Idp homepage", with: @saml.idp_homepage
    fill_in "Idp sso target url", with: @saml.idp_sso_target_url
    fill_in "Lastname attribute", with: @saml.lastname_attribute
    fill_in "Lock version", with: @saml.lock_version
    fill_in "Name attribute", with: @saml.name_attribute
    fill_in "Name identifier format", with: @saml.name_identifier_format
    fill_in "Provider", with: @saml.provider
    fill_in "Roles attribute", with: @saml.roles_attribute
    fill_in "Sp entity", with: @saml.sp_entity_id
    fill_in "Username attribute", with: @saml.username_attribute
    click_on "Update Saml"

    assert_text "Saml was successfully updated"
    click_on "Back"
  end

  test "destroying a Saml" do
    visit samls_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Saml was successfully destroyed"
  end
end
