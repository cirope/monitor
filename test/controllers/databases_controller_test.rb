# frozen_string_literal: true

require 'test_helper'

class DatabasesControllerTest < ActionController::TestCase
  setup do
    @database = send 'public.databases', :postgresql

    login user: users(:god)
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

  test 'should get filtered index for autocomplete' do
    get :index, params: { q: @database.name }, as: :json
    assert_response :success

    databases = JSON.parse @response.body

    assert_equal 1, databases.size
    assert_equal @database.id, databases.first['id']
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create database' do
    username = password = ENV['GH_ACTIONS'] ? 'postgres' : 'monitor'

    assert_difference('Database.count' => 1, 'Property.count' => 4) do
      post :create, params: {
        database: {
          name:        'PostgreSQL Test',
          driver:      'PostgreSQL Unicode',
          description: 'PostgreSQL test',
          properties_attributes: [
            { key: 'port',     value: '5432'         },
            { key: 'database', value: 'monitor_test' },
            { key: 'username', value: username       },
            { key: 'password', value: password       }
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
