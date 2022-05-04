# frozen_string_literal: true

require 'test_helper'

class Scripts::ImportsControllerTest < ActionController::TestCase
  setup do
    login
  end

  teardown do
    Current.account = nil
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create' do
    Current.account = send 'public.accounts', :default
    path            = Script.for_export.export

    post :create, params: {
      file: Rack::Test::UploadedFile.new(path, 'application/zip')
    }

    assert_response :success
    assert_equal I18n.t('scripts.imports.create.scripts_imported'), flash.notice

    FileUtils.rm path
  end

  test 'should not import if invalid script' do
    Current.account = send 'public.accounts', :default
    scripts         = Script.for_export
    old_name        = scripts.first.name

    scripts.first.update_attribute 'name', ''

    path = scripts.export

    scripts.first.update_attribute 'name', old_name

    post :create, params: {
      file: Rack::Test::UploadedFile.new(path, 'application/zip')
    }

    assert_response :success
    assert_equal I18n.t('scripts.imports.create.fail'), flash.alert
    assert_equal old_name, scripts.first.reload.name

    FileUtils.rm path
  end

  test 'should not import if no file' do
    post :create

    assert_redirected_to scripts_imports_new_url
    assert_equal I18n.t('scripts.imports.create.no_file'), flash.alert
  end

  test 'should not import if file has incorrect format' do
    post :create, params: {
      file: fixture_file_upload('test/fixtures/files/test.sh', 'text/plain', false)
    }

    assert_redirected_to scripts_imports_new_url
    assert_equal I18n.t('scripts.imports.create.file_invalid_extension'),
                 flash.alert
  end

  test 'should not import if the zip has invalid json' do
    post :create, params: {
      file: fixture_file_upload('test/fixtures/files/invalid_json.zip', 'application/zip', false)
    }

    assert_redirected_to scripts_imports_new_url
    assert_equal I18n.t('scripts.imports.create.internal_format_invalid'),
                 flash.alert
  end
end
