# frozen_string_literal: true

require 'test_helper'

class Issues::ExportsControllerTest < ActionController::TestCase
  setup do
    login
  end

  test 'should create' do
    post :create, params: { ids: Issue.pluck('id') }
    assert_response :success
    assert_equal 'application/zip', response.content_type
  end

  test 'should create using session default' do
    post :create, session: { board_issues: Issue.pluck('id') }
    assert_response :success
    assert_equal 'application/zip', response.content_type
  end

  test 'should create grouped zip' do
    post :create, params: { ids: Issue.pluck('id'), grouped: true }
    assert_response :success
    assert_equal 'application/zip', response.content_type
  end
end
