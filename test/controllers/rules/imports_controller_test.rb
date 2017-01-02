require 'test_helper'

class Rules::ImportsControllerTest < ActionController::TestCase
  setup do
    login
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create' do
    path = Rule.all.export

    post :create, params: {
      file: Rack::Test::UploadedFile.new(path, 'application/zip')
    }

    assert_redirected_to rules_url
    assert_equal I18n.t('rules.imports.create.imported'), flash.notice

    FileUtils.rm path
  end

  test 'should not import if no file' do
    post :create
    assert_redirected_to rules_imports_new_url
    assert_equal I18n.t('rules.imports.create.no_file'), flash.alert
  end

  test 'should not import if file has incorrect format' do
    post :create, params: {
      file: fixture_file_upload('files/test.sh', 'text/plain', false)
    }

    assert_redirected_to rules_url
    assert_equal I18n.t('rules.imports.create.fail'), flash.alert
  end
end
