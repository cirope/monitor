# frozen_string_literal: true

require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  include ActionMailer::TestHelper

  setup do
    @ticket = issues :ticket

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should destroy ticket' do
    owner = @ticket.owner

    assert_no_difference 'Issue.count' do
      delete :destroy, params: { id: @ticket }
    end

    assert_nil @ticket.reload.owner_id
    assert_not_nil @ticket.reload.owner_type
    assert_redirected_to owner
  end
end
