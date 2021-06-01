# frozen_string_literal: true

require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  setup do
    @tag = tags :starters

    login
  end

  test 'should get index' do
    get :index, params: { kind: @tag.kind }
    assert_response :success
  end

  test 'should get filtered index' do
    get :index, params: { kind: @tag.kind, q: @tag.name }, as: :json
    assert_response :success

    tags = JSON.parse @response.body

    assert_equal 1, tags.size
    assert_equal @tag.name, tags.first['name']
  end

  test 'should get excluded filtered index' do
    get :index, params: { kind: @tag.kind, q: @tag.name, exclude: @tag.id }, as: :json
    assert_response :success

    tags = JSON.parse @response.body

    assert_equal 0, tags.size
  end

  test 'should get group filtered index' do
    tag = tags :important

    get :index, params: { kind: tag.kind, q: tag.name, group: true }, as: :json
    assert_response :success

    tags = JSON.parse @response.body

    assert_equal 1, tags.size
    assert_equal tag.name, tags.first['name']
  end

  test 'should get new' do
    get :new, params: { kind: @tag.kind }
    assert_response :success
  end

  test 'should create tag' do
    kind = @tag.kind

    assert_difference 'Tag.where(kind: kind).count' do
      post :create, params: {
        kind: kind,
        tag: {
          name: 'Test tag',
          style: 'secondary'
        }
      }
    end

    assert_redirected_to tag_url(Tag.last, kind: kind)
  end

  test 'should create tag with effects and parent' do
    parent = tags :important
    kind   = parent.kind
    counts = [
      'Tag.where(kind: kind).count',
      'Effect.count',
      'parent.children.count'
    ]

    assert_difference counts do
      post :create, params: {
        kind: kind,
        tag: {
          name: 'Test tag',
          style: 'secondary',
          parent_id: parent.id.to_s,
          effects_attributes: [
            {
              implied_id: tags(:final).id.to_s
            }
          ]
        }
      }
    end

    assert_redirected_to tag_url(Tag.last, kind: kind)
  end

  test 'should show tag' do
    get :show, params: { kind: @tag.kind, id: @tag }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { kind: @tag.kind, id: @tag }
    assert_response :success
  end

  test 'should update tag' do
    patch :update, params: {
      kind: @tag.kind,
      id: @tag,
      tag: { name: 'Updated text tag' }
    }

    assert_redirected_to tag_url(@tag, kind: @tag.kind)
  end

  test 'should destroy tag' do
    assert_difference 'Tag.count', -1 do
      delete :destroy, params: { id: @tag, kind: @tag.kind }
    end

    assert_redirected_to tags_url(kind: @tag.kind)
  end
end
