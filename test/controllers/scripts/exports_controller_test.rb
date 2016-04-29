require 'test_helper'

class Scripts::ExportsControllerTest < ActionController::TestCase
  setup do
    login
  end

  test 'should create' do
    post :create
    assert_response :success
    assert_equal 'application/zip', response.content_type
  end
end
