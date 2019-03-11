# frozen_string_literal: true

require 'test_helper'

class Rules::ExportsControllerTest < ActionController::TestCase
  setup do
    login
  end

  test 'should create' do
    post :create
    assert_response :success
    assert_equal 'application/zip', response.content_type
  end

  test 'should create by id' do
    post :create, params: { id: rules(:cd_email).id }
    assert_response :success
    assert_equal 'application/zip', response.content_type
  end
end
