# frozen_string_literal: true

require 'test_helper'

class FilesControllerTest < ActionController::TestCase
  setup do
    login
  end

  test 'should download file' do
    relative_path = "#{SecureRandom.uuid}.txt"
    full_path     = "#{Rails.root}/private/#{relative_path}"

    FileUtils.touch full_path

    get :show, params: { path: relative_path }
    assert_response :success
    assert_equal File.open(full_path, encoding: 'ASCII-8BIT').read, @response.body

    FileUtils.rm full_path
  end

  test 'should not download file' do
    get :show, params: { path: 'wrong/path.txt' }
    assert_redirected_to root_url
    assert_equal I18n.t('messages.file_not_found'), flash.notice
  end
end
