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
end
