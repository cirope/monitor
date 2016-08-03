require 'test_helper'

class DatabasesControllerTest < ActionController::TestCase
  setup do
    @database = databases :postgresql

    login users(:god)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get filtered index' do
    get :index, params: { filter: { name: 'undefined' } }
    assert_response :success
    assert_select '.alert', text: I18n.t('databases.index.empty_search_html')
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create database' do
    assert_difference ['Database.count', 'Property.count'] do
      post :create, params: {
        database: {
          name:        'MySQL',
          driver:      'MySQL',
          description: 'MySQL test',
          properties_attributes: [
            { key: 'Trace', value: 'No' }
          ]
        }
      }
    end

    assert_redirected_to database_url(Database.last)
  end

  test 'should show database' do
    get :show, params: { id: @database }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @database }
    assert_response :success
  end

  test 'should update database' do
    patch :update, params: {
      id: @database,
      database: { name: 'PostgreSQL (updated)' }
    }

    assert_redirected_to database_url(@database)
  end

  test 'should destroy database' do
    assert_difference 'Database.count', -1 do
      delete :destroy, params: { id: @database }
    end

    assert_redirected_to databases_url
  end
end
