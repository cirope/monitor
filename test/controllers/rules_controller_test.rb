require 'test_helper'

class RulesControllerTest < ActionController::TestCase
  setup do
    @rule = rules :cd_email

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get filtered index for autocomplete' do
    get :index, params: { q: @rule.name }, as: :json
    assert_response :success

    rules = JSON.parse @response.body

    assert_equal 1, rules.size
    assert_equal @rule.name, rules.first['name']
  end

  test 'should get filtered index' do
    get :index, params: { filter: { name: 'undefined' } }
    assert_response :success
    assert_select '.alert', text: I18n.t('rules.index.empty_search_html')
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create rule' do
    assert_difference ['Rule.count', 'Trigger.count'] do
      post :create, params: {
        rule: {
          name: 'Send email if anything goes wrong',
          enabled: '1',
          triggers_attributes: [
            {
              callback: 'puts "test callback"',
              action: 'puts "test action"'
            }
          ]
        }
      }
    end

    assert_redirected_to rule_url(Rule.last)
  end

  test 'should show rule' do
    get :show, params: { id: @rule }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @rule }
    assert_response :success
  end

  test 'should update rule' do
    patch :update, params: {
      id: @rule,
      rule: { name: 'Updated name' }
    }

    assert_redirected_to rule_url(@rule)
  end

  test 'should destroy rule' do
    assert_difference 'Rule.count', -1 do
      delete :destroy, params: { id: @rule }
    end

    assert_redirected_to rules_url
  end
end
