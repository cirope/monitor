require 'test_helper'

class ExecutionsControllerTest < ActionController::TestCase

  setup do
    @execution = executions :live_ls

    login
  end

  test 'should get index' do
    get :index, params: { script_id: @execution.script_id }
    assert_response :success
  end

  test 'should create execution' do
    assert_difference 'Execution.count' do
      post :create, params: { script_id: @execution.script_id }
    end

    assert_redirected_to script_execution_url(@execution.script, Execution.last)
  end

  test 'should show execution' do
    get :show, params: { id: @execution, script_id: @execution.script_id }
    assert_response :success
  end
end
