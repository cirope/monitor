# frozen_string_literal: true

require 'test_helper'

class Api::V1::IssuesControllerTest < ActionController::TestCase
  setup do
    @script  = scripts :ls
    @account = Account.first
  end

  test 'index return error with invalid account and script' do
    get :index, params: { account_id: 'not exist', script_id: 'a' }

    assert_response :missing
    assert_match I18n.t('api.v1.issues.account_not_exist'), response.body
    assert_match I18n.t('api.v1.issues.script_incorrect'), response.body
    assert_match I18n.t('api.v1.issues.script_not_exist'), response.body
  end

  test 'index return error with invalid account' do
    get :index, params: { account_id: 'not exist', script_id: @script.id }

    assert_response :missing
    assert_match I18n.t('api.v1.issues.account_not_exist'), response.body
    assert_match I18n.t('api.v1.issues.script_not_exist'), response.body
  end

  test 'index return error with invalid script' do
    get :index, params: { account_id: @account.tenant_name, script_id: Script.last.id + 1 }

    assert_response :missing
    assert_match I18n.t('api.v1.issues.script_not_exist'), response.body
  end

  test 'index without colapse data' do
    get :index, params: { account_id: @account.tenant_name, script_id: @script.id }

    assert_response :success

    json_expected = @script.issues.to_json(methods: :url, except: %i[data options run_id])
    assert_match json_expected, response.body
  end

  test 'index with colapse data' do
    @script.issues.each do |issue|
      issue.update! data: [['Header'], ['Value']]
    end

    get :index, params: { account_id: @account.tenant_name, script_id: @script.id }

    assert_response :success

    json_expected = @script.issues
                           .map { |issue| issue.converted_data.first.merge status: issue.status, url: issue.url }
                           .to_json

    assert_match json_expected, response.body
  end

  test 'index without data' do
    script_without_issues = scripts :cd_root

    get :index, params: { account_id: @account.tenant_name, script_id: script_without_issues.id }

    assert_response :success

    assert_match [].to_json, response.body
  end
end
