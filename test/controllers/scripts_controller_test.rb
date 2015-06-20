require 'test_helper'

class ScriptsControllerTest < ActionController::TestCase

  setup do
    @script = scripts :ls

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:scripts)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create script' do
    assert_difference 'Script.count' do
      post :create, script: {
        name: 'Test script', file: @script.file, text: @script.text
      }
    end

    assert_redirected_to script_url(assigns(:script))
  end

  test 'should show script' do
    get :show, id: @script
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @script
    assert_response :success
  end

  test 'should update script' do
    patch :update, id: @script, script: { name: 'Updated text script' }
    assert_redirected_to script_url(assigns(:script))
  end

  test 'should destroy script' do
    assert_difference 'Script.count', -1 do
      delete :destroy, id: @script
    end

    assert_redirected_to scripts_url
  end
end
