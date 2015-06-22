require 'test_helper'

class ScriptTest < ActiveSupport::TestCase
  def setup
    @script = scripts :ls
  end

  test 'blank attributes' do
    @script.name = ''
    @script.text = ''
    @script.file = nil

    assert @script.invalid?
    assert_error @script, :name, :blank
    assert_error @script, :text, :blank
  end

  test 'unique attributes' do
    script = @script.dup

    assert script.invalid?
    assert_error script, :name, :taken
  end

  test 'not text and file validation' do
    @script.file = Rack::Test::UploadedFile.new(
      "#{Rails.root}/test/fixtures/files/test.sh", 'text/plain', false
    )

    assert @script.invalid?
    assert_error @script, :file, :invalid
  end

  test 'search' do
    scripts = Script.search query: @script.name

    assert scripts.present?
    assert scripts.all? { |s| s.name =~ /#{@script.name}/ }
  end
end
