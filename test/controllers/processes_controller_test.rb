# frozen_string_literal: true
require 'test_helper'

class ProcessesControllerTest < ActionController::TestCase
  test 'should get index' do
    login

    get :index

    assert_response :success
  end

  test 'should finish pid' do
    login

    pid     = spawn 'sleep 0.04'
    sleep_p = SystemProcess.new pid

    Process.detach pid # not wait for main process finish

    assert sleep_p.still_running?

    delete :destroy, params: { id: pid }

    assert_redirected_to processes_url
    assert_equal I18n.t('processes.destroy.destroyed'), flash[:notice]

    refute sleep_p.still_running?
  end

  test 'should not finish pid' do
    login

    delete :destroy, params: { id: 999999 }

    assert_redirected_to processes_url
    assert_equal I18n.t('processes.destroy.cannot_be_destroyed'), flash[:notice]
  end

  test 'should not finish pid without supervisor' do
    login user: users(:eduardo)

    pid     = spawn 'sleep 0.04'
    sleep_p = SystemProcess.new pid

    Process.detach pid # not wait for main process finish

    assert sleep_p.still_running?

    delete :destroy, params: { id: pid }

    assert_redirected_to root_url
    assert_equal I18n.t('messages.not_authorized'), flash[:alert]
    assert sleep_p.still_running?

    sleep_p.kill
  end

  test 'should not get index as guest' do
    login user: users(:john)

    get :index

    assert_redirected_to root_url
    assert_equal I18n.t('messages.not_authorized'), flash[:alert]
  end
end
