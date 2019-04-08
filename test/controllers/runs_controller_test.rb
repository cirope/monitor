# frozen_string_literal: true

require 'test_helper'

class RunsControllerTest < ActionController::TestCase
  setup do
    @run = runs :ls_on_atahualpa

    login
  end

  test 'should get index' do
    get :index, params: { schedule_id: @run.schedule.id }
    assert_response :success
  end

  test 'should get filtered index' do
    get :index, params: {
      schedule_id: @run.schedule.id,
      filter: { status: 'undefined' }
    }
    assert_response :success
    assert_select '.alert', text: I18n.t('runs.index.empty_search_html')
  end

  test 'should show run' do
    get :show, params: { id: @run }
    assert_response :success
  end

  test 'should update run' do
    patch :update, params: { id: @run }, xhr: true, as: :js
    assert_response :success
  end

  test 'should update run with force param' do
    patch :update, params: { id: @run, force: true }, xhr: true, as: :js
    assert_response :success
  end

  test 'should destroy run' do
    assert_difference 'Run.count', -1 do
      delete :destroy, params: { id: @run }
    end

    assert_redirected_to schedule_runs_url(@run.schedule)
  end
end
