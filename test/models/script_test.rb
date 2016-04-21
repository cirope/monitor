require 'test_helper'

class ScriptTest < ActiveSupport::TestCase
  setup do
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

  test 'attributes length' do
    @script.name = 'abcde' * 52
    @script.change = 'abcde' * 52

    assert @script.invalid?
    assert_error @script, :name, :too_long, count: 255
    assert_error @script, :change, :too_long, count: 255
  end

  test 'not text and file validation' do
    @script.file = Rack::Test::UploadedFile.new(
      "#{Rails.root}/test/fixtures/files/test.sh", 'text/plain', false
    )

    assert @script.invalid?
    assert_error @script, :file, :invalid
  end

  test 'text modification should ask change' do
    @script.change = ''

    assert @script.valid?

    @script.text = 'puts "123"'

    assert @script.invalid?
    assert_error @script, :change, :blank
  end

  test 'can not destroy when issues' do
    assert_no_difference 'Script.count' do
      @script.destroy
    end
  end

  test 'search' do
    scripts = Script.search query: @script.name

    assert scripts.present?
    assert scripts.all? { |s| s.name =~ /#{@script.name}/ }
  end

  test 'body' do
    assert_match @script.text, @script.body
  end

  test 'body inclusions' do
    script = scripts :cd_root
    body   = @script.body

    assert_match script.text, body
    assert_match @script.text, body
  end

  test 'body includes defaults' do
    Script.create! name: 'Core test', core: true, text: 'puts "Core script"', change: 'Initial'

    assert_match /Core script/, @script.body
  end

  test 'copy to' do
    skip
  end

  test 'tagged with' do
    tag     = tags :starters
    scripts = Script.tagged_with tag.name

    assert_not_equal 0, scripts.count
    assert_not_equal 0, scripts.take.tags.count
    assert scripts.all? { |script| script.tags.any? { |t| t.name == tag.name } }
  end

  test 'can be edited by' do
    user = @script.maintainers.take.user

    assert @script.can_be_edited_by?(user)

    user = users :john

    assert !@script.can_be_edited_by?(user)

    user = users :franco

    assert @script.can_be_edited_by?(user)
  end
end
