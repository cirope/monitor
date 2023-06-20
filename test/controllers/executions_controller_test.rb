# frozen_string_literal: true

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
    script = scripts :ls

    assert_difference 'Execution.count' do
      post :create, params: { script_id: script.id }
    end

    assert_redirected_to script_execution_url(script, Execution.last)
  end

  test 'should show execution' do
    get :show, params: { id: @execution, script_id: @execution.script_id }
    assert_response :success
  end

  test 'should show execution as JS' do
    get :show, params: {
      id: @execution, script_id: @execution.script_id
    }, xhr: true, as: :js

    assert_response :success
  end

  test 'should update execution' do
    patch :update, params: {
      id: @execution, script_id: @execution.script_id
    }, xhr: true, as: :js

    assert_response :success
  end

  test 'should update execution with force param' do
    patch :update, params: {
      id: @execution, script_id: @execution.script_id, force: true
    }, xhr: true, as: :js

    assert_response :success
  end

  test 'should destroy server' do
    assert_difference 'Execution.count', -1 do
      delete :destroy, params: { id: @execution, script_id: @execution.script_id }
    end

    assert_redirected_to [@execution.script, :executions]
  end

  test 'should cleanup executions' do
    script     = @execution.script
    executions = script.executions.count

    assert_not_equal 0, executions

    assert_difference 'Execution.count', -executions do
      delete :cleanup, params: { script_id: script }
    end

    assert_redirected_to script
  end
end
