# frozen_string_literal: true

require 'test_helper'

class FilesControllerTest < ActionController::TestCase
  setup do
    login

    Current.account = send 'public.accounts', :default
  end

  teardown do
    Current.account = nil
  end

  test 'should download file' do
    relative_path = "#{Current.account.tenant_name}/#{SecureRandom.uuid}.txt"
    full_path     = "#{Rails.root}/private/#{relative_path}"

    FileUtils.mkdir_p "#{Rails.root}/private/#{Current.account.tenant_name}"

    File.open(full_path, 'w') { |f| f << 'Test content' }

    get :show, params: { path: relative_path }
    assert_response :success
    assert_equal 'Test content', @response.body

    FileUtils.rm full_path
  end

  test 'should not download file' do
    get :show, params: { path: 'wrong/path.txt' }
    assert_redirected_to root_url
    assert_equal I18n.t('messages.file_not_found'), flash.notice
  end
end
