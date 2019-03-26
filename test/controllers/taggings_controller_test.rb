# frozen_string_literal: true

require 'test_helper'

class TaggingsControllerTest < ActionController::TestCase
  setup do
    @tagging = taggings :ls_on_atahualpa_not_well_as_important
    @issue   = @tagging.taggable

    login
  end

  test 'should get new' do
    get :new, xhr: true, as: :js, params: { issue_id: @issue }
    assert_response :success
  end

  test 'should create tagging' do
    assert_difference '@issue.taggings.count' do
      post :create, xhr: true, as: :js, params: {
        issue_id: @issue,
        tagging:  {
          tag_id: tags(:final).id
        }
      }
    end

    assert_response :success
  end

  test 'should destroy tagging' do
    assert_difference '@issue.taggings.count', -1 do
      delete :destroy, xhr: true, as: :js, params: {
        id:       @tagging,
        issue_id: @issue
      }
    end

    assert_response :success
  end
end
