# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users :eduardo

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get filtered index for autocomplete' do
    get :index, params: { q: @user.name, role: @user.role.type }, as: :json
    assert_response :success

    users = JSON.parse @response.body

    assert_equal 1, users.size
    assert_equal @user.email, users.first['email']
  end

  test 'should get filtered index' do
    get :index, params: { filter: { name: 'undefined' } }
    assert_response :success
    assert_select '.alert', text: I18n.t('users.index.empty_search_html')
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create user' do
    assert_difference ['User.count', 'Tagging.count'] do
      post :create, params: {
        user: {
          name: @user.name,
          lastname: @user.lastname,
          email: 'new@user.com',
          password: '123',
          password_confirmation: '123',
          role_id: roles(:supervisor).id,
          taggings_attributes: [
            {
              tag_id: tags(:admins).id.to_s
            }
          ]
        }
      }
    end

    assert_redirected_to user_url(User.last)
  end

  test 'should show user' do
    get :show, params: { id: @user }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @user }
    assert_response :success
  end

  test 'should update user' do
    patch :update, params: {
      id: @user,
      user: { name: 'Updated name' }
    }

    assert_redirected_to user_url(@user)
  end

  test 'should destroy user' do
    assert_difference('User.visible.count', -1) do
      delete :destroy, params: { id: @user }
    end

    assert_redirected_to users_url
  end

  test 'should not authorize controller' do
    login user: users(:john)

    get :index
    assert_redirected_to login_url
  end
end
