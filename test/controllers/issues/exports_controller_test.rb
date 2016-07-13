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
end
