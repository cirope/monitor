require 'test_helper'

class Scripts::ImportsControllerTest < ActionController::TestCase
  setup do
    login
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create' do
    path = Script.for_export.export

    post :create, file: Rack::Test::UploadedFile.new(path, 'application/zip')
    assert_redirected_to scripts_url
    assert_equal I18n.t('scripts.imports.create.imported'), flash.notice

    FileUtils.rm path
  end

  test 'should not import if no file' do
    post :create
    assert_redirected_to scripts_imports_new_url
    assert_equal I18n.t('scripts.imports.create.no_file'), flash.alert
  end

  test 'should not import if file has incorrect format' do
    post :create, file: fixture_file_upload('files/test.sh', 'text/plain', false)
    assert_redirected_to scripts_url
    assert_equal I18n.t('scripts.imports.create.fail'), flash.alert
  end
end
