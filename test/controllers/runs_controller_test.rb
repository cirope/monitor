require 'test_helper'

class RunsControllerTest < ActionController::TestCase

  setup do
    @run = runs :ls_on_atahualpa

    login
  end

  test 'should get index' do
    get :index, schedule_id: @run.schedule.id
    assert_response :success
    assert_not_nil assigns(:runs)
  end

  test 'should show run' do
    get :show, id: @run
    assert_response :success
  end

  test 'should destroy run' do
    assert_difference 'Run.count', -1 do
      delete :destroy, id: @run
    end

    assert_redirected_to schedule_runs_url(@run.schedule)
  end
end
