# frozen_string_literal: true

require 'test_helper'

class Issues::StatusControllerTest < ActionController::TestCase
  setup do
    @issue = issues :ls_on_atahualpa_not_well
    user   = users :john

    user.update! role: 'owner'

    login user: user
  end

  test 'should get update' do
    patch :update, params: {
      id:    @issue.id,
      issue: {
        status: 'taken'
      }
    }, as: :js, xhr: true

    assert_response :success
    assert @issue.reload.taken?
  end
end
