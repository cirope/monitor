# frozen_string_literal: true

require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  setup do
    @controller.send 'response=', @response
    @controller.send 'request=', @request
  end

  test 'should set title' do
    @controller = UsersController.new
    @controller.action_name = 'create'

    assert_equal I18n.t('users.new.title'), set_title

    @controller.action_name = 'edit'

    assert_equal I18n.t('users.edit.title'), set_title
  end

  test 'should override action aliases' do
    @controller = UsersController.new
    @controller.action_name = 'test'

    def @controller.action_aliases; super.merge(test: 'alias'); end

    assert_equal I18n.t('users.alias.title'), set_title
  end

  test 'should current user be nil' do
    assert_nil current_user
  end

  test 'should load current user when auth_token is present' do
    login

    assert_not_nil current_user
  end

  test 'should update user' do
    user = users :franco

    user.update name: 'Updated'

    assert_equal 'Updated', user.reload.name
  end

  test 'should redirect on update if stale' do
    skip
  end

  test 'should store location' do
    @request.instance_variable_set(:@fullpath, issues_path)

    store_location

    assert_equal issues_path, session[:previous_url]
  end

  test 'should not store location' do
    @request.instance_variable_set(:@fullpath, login_path)

    store_location

    assert_nil session[:previous_url]
  end

  private

    def set_title
      @controller.send :set_title
    end

    def current_user
      @controller.send :current_user
    end

    def store_location
      @controller.send :store_location
    end
end
