# frozen_string_literal: true

require 'test_helper'

class Rules::VersionsControllerTest < ActionController::TestCase
  setup do
    @rule    = rules :cd_email
    @version = versions :email_creation

    login
  end

  test 'should get index' do
    get :index, params: { rule_id: @rule.id }
    assert_response :success
  end

  test 'should get show' do
    get :show, params: { rule_id: @rule.id, id: @version }
    assert_response :success
  end
end
