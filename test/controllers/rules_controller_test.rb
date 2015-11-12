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

  test 'should filtered index' do
    get :index, q: @rule.name, format: :json
    assert_response :success

    rules = assigns :rules
    assert_equal 1, rules.size
    assert_equal @rule.name, rules.first.name
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create rule' do
    assert_difference ['Rule.count', 'Trigger.count'] do
      post :create, rule: {
        name: 'Send email if anything goes wrong',
        enabled: '1',
        triggers_attributes: [
          {
            callback: 'puts "test callback"',
            action: 'puts "test action"'
          }
        ]
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
    patch :update, id: @rule, rule: { name: 'Updated name' }
    assert_redirected_to rule_url(assigns(:rule))
  end

  test 'should destroy rule' do
    assert_difference 'Rule.count', -1 do
      delete :destroy, id: @rule
    end

    assert_redirected_to rules_url
  end
end
