require 'test_helper'

class DatabasesControllerTest < ActionController::TestCase
  setup do
    @database = databases :postgresql

    login users(:god)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:databases)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create database' do
    assert_difference ['Database.count', 'Property.count'] do
      post :create, database: {
        name:        'MySQL',
        driver:      'MySQL',
        description: 'MySQL test',
        properties_attributes: [
          { key: 'Trace', value: 'No' }
        ]
      }
    end

    assert_redirected_to database_url assigns(:database)
  end

  test 'should show database' do
    get :show, id: @database
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @database
    assert_response :success
  end

  test 'should update database' do
    patch :update, id: @database, database: { name: 'PostgreSQL (updated)' }

    assert_redirected_to database_url assigns(:database)
  end

  test 'should destroy database' do
    assert_difference 'Database.count', -1 do
      delete :destroy, id: @database
    end

    assert_redirected_to databases_url
  end
end
