require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users :john

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test 'should filtered index' do
    get :index, q: @user.name, role: @user.role, format: :json
    assert_response :success

    users = assigns :users
    assert_equal 1, users.size
    assert_equal @user.name, users.first.name
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create user' do
    assert_difference ['User.count', 'Tagging.count'] do
      post :create, user: {
        name: @user.name,
        lastname: @user.lastname,
        email: 'new@user.com',
        password: '123',
        password_confirmation: '123',
        taggings_attributes: [
          {
            tag_id: tags(:admins).id.to_s
          }
        ]
      }
    end

    assert_redirected_to user_url(assigns(:user))
  end

  test 'should show user' do
    get :show, id: @user
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @user
    assert_response :success
  end

  test 'should update user' do
    patch :update, id: @user, user: { name: 'Updated name' }
    assert_redirected_to user_url(assigns(:user))
  end

  test 'should destroy user' do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    assert_redirected_to users_url
  end
end
