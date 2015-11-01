require 'test_helper'

class RulesControllerTest < ActionController::TestCase
  setup do
    @rule = rules :cd_email

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:rules)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create rule' do
    assert_difference 'Rule.count' do
      post :create, rule: {
        to: 'john@doe.com', name: 'John Doe (when arrives)', enabled: '1'
      }
    end

    assert_redirected_to rule_url(assigns(:rule))
  end

  test 'should show rule' do
    get :show, id: @rule
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @rule
    assert_response :success
  end

  test 'should update rule' do
    patch :update, id: @rule, rule: { name: 'New name' }
    assert_redirected_to rule_url(assigns(:rule))
  end

  test 'should destroy rule' do
    assert_difference 'Rule.count', -1 do
      delete :destroy, id: @rule
    end

    assert_redirected_to rules_url
  end
end
