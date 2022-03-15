# frozen_string_literal: true

require 'test_helper'

class ViewsControllerTest < ActionController::TestCase
  test 'should create view' do
    user  = users(:john)
    issue = issues(:ls_on_atahualpa_not_well)

    login user: user

    assert_difference 'View.count', 1 do
      post :create, params: { issue_id: issue.id }, format: :js
      assert_response :success
      assert_equal issue.id, user.views.last.issue_id
    end
  end
end
