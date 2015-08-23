require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @tag = tags :starters

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:tags)
  end

  test 'should get filtered index' do
    get :index, q: @tag.name, format: :json
    assert_response :success

    tags = assigns :tags
    assert_equal 1, tags.size
    assert_equal @tag.name, tags.first.name
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create tag' do
    assert_difference 'Tag.count' do
      post :create, tag: {
        name: 'Test tag'
      }
    end

    assert_redirected_to tag_url(assigns(:tag))
  end

  test 'should show tag' do
    get :show, id: @tag
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @tag
    assert_response :success
  end

  test 'should update tag' do
    patch :update, id: @tag, tag: { name: 'Updated text tag' }
    assert_redirected_to tag_url(assigns(:tag))
  end

  test 'should destroy tag' do
    assert_difference 'Tag.count', -1 do
      delete :destroy, id: @tag
    end

    assert_redirected_to tags_url
  end
end
