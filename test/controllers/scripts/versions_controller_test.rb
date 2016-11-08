require 'test_helper'

class Scripts::VersionsControllerTest < ActionController::TestCase
  setup do
    @version = versions :cd_root_creation

    login
  end

  test 'should get index' do
    get :index, params: { script_id: @version.item_id }
    assert_response :success
  end

  test 'should get show' do
    get :show, params: { script_id: @version.item_id, id: @version }
    assert_response :success
  end
end
