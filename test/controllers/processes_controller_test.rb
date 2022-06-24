# frozen_string_literal: true
require 'test_helper'

class ProcessesControllerTest < ActionController::TestCase
  test 'should get index' do
    login

    get :index

    assert_response :success
  end

  test 'should finish pid' do
    skip if RUBY_PLATFORM.include?('darwin')

    login

    sleep_p = sleep_process interval: 0.04

    assert sleep_p.still_running?

    delete :destroy, params: { id: sleep_p.pid }

    assert_redirected_to processes_url
    assert_equal I18n.t('processes.destroy.destroyed'), flash[:notice]

    sleep 0.25 if ENV['GH_ACTIONS']

    refute sleep_p.still_running?
  end

  test 'should not finish pid' do
    login

    delete :destroy, params: { id: 999999 }

    assert_redirected_to processes_url
    assert_equal I18n.t('processes.destroy.cannot_be_destroyed'), flash[:notice]
  end

  test 'should not finish pid without supervisor' do
    skip if RUBY_PLATFORM.include?('darwin')

    login user: users(:eduardo)

    sleep_p = sleep_process interval: 0.06

    assert sleep_p.still_running?

    delete :destroy, params: { id: sleep_p.pid }

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

  private

    def sleep_process interval: 0.01
      interval *= 100 if ENV['GH_ACTIONS']

      detached_process command: "sleep #{interval}"
    end

    def detached_process command: ''
      pid         = spawn command
      cmd_process = SystemProcess.new pid

      Process.detach pid # not wait for main process finish

      cmd_process
    end
end
