# frozen_string_literal: true

require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  include ActionMailer::TestHelper

  setup do
    @ticket = tickets :ticket_script

    login
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create ticket' do
    assert_difference 'Ticket.count' do
      post :create, params: {
        ticket: {
          owner_type: Script,
          title: 'New Ticket',
          description: 'New Description'
        }
      }
    end

    assert_redirected_to ticket_url(Ticket.last)
  end

  test 'should show ticket' do
    get :show, params: { id: @ticket }
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @ticket }
    assert_response :success
  end

  test 'should update ticket' do
    assert_difference ['Subscription.count', 'Comment.count', 'Tagging.count'] do
      patch :update, params: {
        id: @ticket,
        ticket: {
          title: 'Ticket update',
          status: 'taken',
          subscriptions_attributes: [
            { user_id: users(:eduardo).id.to_s }
          ],
          taggings_attributes: [
            {
              tag_id: tags(:final).id.to_s
            }
          ],
          comments_attributes: [
            {
              text: 'test comment',
              file: fixture_file_upload('test/fixtures/files/test.sh', 'text/plain', false)
            }
          ]
        }
      }
    end

    assert_redirected_to ticket_url(@ticket)
  end

  test 'should destroy ticket' do
    owner = @ticket.owner

    assert_no_difference 'Issue.count' do
      delete :destroy, params: { id: @ticket }
    end

    @ticket.reload

    assert_nil @ticket.owner_id
    assert_not_nil @ticket.owner_type
    assert_redirected_to owner
  end
end
