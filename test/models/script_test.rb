# frozen_string_literal: true

require 'test_helper'

class Script
  def current_version
    ENV['TEST_VERSION'] || MonitorApp::Application::VERSION
  end
end

class ScriptTest < ActiveSupport::TestCase
  setup do
    @script = scripts :ls
  end

  teardown do
    Current.account = nil
  end

  test 'blank attributes' do
    @script.name = ''
    @script.text = ''
    @script.attachment = nil

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

  test 'validates attributes encoding' do
    @script.text = "\n\t"

    assert @script.invalid?
    assert_error @script, :text, :pdf_encoding
  end

  test 'not text and file validation' do
    @script.attachment = Rack::Test::UploadedFile.new(
      "#{Rails.root}/test/fixtures/files/test.sh", 'text/plain', false
    )

    assert @script.invalid?
    assert_error @script, :attachment, :invalid
  end

  test 'text modification should ask change' do
    @script.change = ''

    assert @script.valid?

    @script.text = 'puts "123"'

    assert @script.invalid?
    assert_error @script, :change, :blank
  end

  test 'invalid script with imported_version' do
    @script.imported_version = MonitorApp::Application::VERSION.next

    refute @script.valid?
  end

  test 'valid script with imported_version' do
    @script.imported_version = MonitorApp::Application::VERSION

    assert @script.valid?
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

  test 'not tagged' do
    Script.take.tags.clear

    scripts = Script.not_tagged

    assert_not_equal 0, scripts.count
    assert scripts.all? { |script| script.tags.empty? }
  end

  test 'for export' do
    scripts = Script.for_export

    assert scripts.all? { |script| script.tags.any? &:export? }
  end

  test 'can be edited by' do
    user = @script.maintainers.take.user

    assert @script.can_be_edited_by?(user)

    user = users :john

    assert !@script.can_be_edited_by?(user)

    user = users :franco

    assert @script.can_be_edited_by?(user)
  end

  test 'to json' do
    json = ActiveSupport::JSON.decode(@script.to_json)

    assert_equal @script.name, json['name']

    if @script.descriptions.present?
      json_descriptions_expected = @script.descriptions
                                          .map { |d| d.attributes.slice('name', 'value') }

      assert_equal json_descriptions_expected, json['descriptions']
    end

    assert_equal MonitorApp::Application::VERSION, json['current_version']
  end

  test 'to pdf' do
    Current.account = send 'public.accounts', :default
    path            = @script.to_pdf

    assert File.exist?(path)

    FileUtils.rm path
  end

  test 'export' do
    Current.account = send 'public.accounts', :default
    path            = Script.export

    assert File.exist?(path)

    FileUtils.rm path
  end

  test 'add to zip' do
    zipfile_path      = "#{SecureRandom.uuid}.zip"
    expected_filename = "#{@script.uuid}.json"

    ::Zip::File.open zipfile_path, Zip::File::CREATE do |zipfile|
      assert !zipfile.find_entry(expected_filename)

      @script.add_to_zip zipfile

      assert zipfile.find_entry(expected_filename)
    end

    FileUtils.rm zipfile_path
  end

  test 'valid extension for import' do
    path = Script.for_export.export

    refute Script.file_invalid? path

    FileUtils.rm path
  end

  test 'invalid extension for import' do
    assert Script.file_invalid? 'test.json'
  end

  test 'import an existing script' do
    Current.account = send 'public.accounts', :default
    path            = Script.where(id: @script.id).export
    scripts         = []

    parameters   = @script.parameters.map { |p| p.attributes.slice('name', 'value') }
    descriptions = @script.descriptions.map { |d| d.attributes.slice('name', 'value') }

    @script.parameters.clear
    @script.descriptions.clear
    @script.requires.clear
    @script.update! name: 'Updated'

    assert_no_difference 'Script.count' do
      scripts = Script.import path
    end

    assert_equal 1, scripts.count
    assert scripts.all? &:valid?
    assert_not_equal 'Updated', @script.reload.name
    assert (scripts.all? { |script| script.imported_version == MonitorApp::Application::VERSION })
    assert_equal @script.parameters.map { |p| p.attributes.slice('name', 'value') },
                 parameters
    assert_equal @script.descriptions.map { |d| d.attributes.slice('name', 'value') },
                 descriptions
    assert @script.requires.any?

    FileUtils.rm path
  end

  test 'import a new script' do
    uuid    = SecureRandom.uuid
    script  = @script.dup
    scripts = []

    @script.parameters.each { |p| script.parameters << p.dup }
    @script.descriptions.each { |d| script.descriptions << d.dup }

    parameters   = script.parameters.map { |p| p.attributes.slice('name', 'value') }
    descriptions = script.descriptions.map { |d| d.attributes.slice('name', 'value') }

    script.name = 'Should be imported as new'
    script.uuid = uuid
    script.save!

    Current.account = send 'public.accounts', :default
    path            = Script.where(id: script.id).export

    script.destroy!

    assert_difference 'Script.count' do
      scripts = Script.import path
    end

    assert_equal 1, scripts.count
    assert scripts.all? &:valid?
    assert (scripts.all? { |script| script.imported_version == MonitorApp::Application::VERSION })
    assert_equal scripts.first.parameters.map { |p| p.attributes.slice('name', 'value') },
                 parameters
    assert_equal scripts.first.descriptions.map { |d| d.attributes.slice('name', 'value') },
                 descriptions
    assert Script.find_by uuid: uuid

    FileUtils.rm path
  end

  test 'import a new script and existing script' do
    uuid    = SecureRandom.uuid
    script  = @script.dup
    scripts = []

    @script.parameters.each { |p| script.parameters << p.dup }
    @script.descriptions.each { |d| script.descriptions << d.dup }

    parameters   = @script.parameters.map { |p| p.attributes.slice('name', 'value') }
    descriptions = @script.descriptions.map { |d| d.attributes.slice('name', 'value') }

    script.name = 'Should be imported as new'
    script.uuid = uuid

    script.save!

    path = Script.where(id: [@script.id, script.id]).export

    script.destroy!

    @script.parameters.clear
    @script.descriptions.clear
    @script.requires.clear
    @script.update! name: 'Updated'

    assert_difference 'Script.count' do
      scripts = Script.import path
    end

    assert_equal 2, scripts.count
    assert scripts.all? &:valid?
    assert (scripts.all? { |script| script.imported_version == MonitorApp::Application::VERSION })
    assert Script.find_by uuid: uuid

    scripts.each do |scripts|
      assert_equal scripts.parameters.map { |p| p.attributes.slice('name', 'value') },
                   parameters
      assert_equal scripts.descriptions.map { |d| d.attributes.slice('name', 'value') },
                   descriptions
    end

    assert_not_equal 'Updated', @script.reload.name
    assert @script.parameters.any?
    assert @script.requires.any?

    FileUtils.rm path
  end

  test 'should not import an invalid script' do
    uuid    = SecureRandom.uuid
    scripts = []

    invalid_script      = @script.dup
    invalid_script.name = 'valid name'
    invalid_script.uuid = uuid

    invalid_script.save!

    invalid_script.update_attribute 'name', ''

    path = Script.where(id: invalid_script.id).export

    invalid_script.destroy!

    assert_no_difference 'Script.count' do
      scripts = Script.import path
    end

    assert_equal 1, scripts.count
    refute scripts.all? &:valid?

    FileUtils.rm path
  end

  test 'should not import a script with a different version' do
    begin
      ENV['TEST_VERSION'] = MonitorApp::Application::VERSION.next

      uuid    = SecureRandom.uuid
      scripts = []

      invalid_script      = @script.dup
      invalid_script.name = 'new version script'
      invalid_script.uuid = uuid

      invalid_script.save!

      def invalid_script.current_version
        MonitorApp::Application::VERSION.next
      end

      path = Script.where(id: invalid_script.id).export

      invalid_script.destroy!

      ENV.delete 'TEST_VERSION'

      assert_no_difference 'Script.count' do
        scripts = Script.import path
      end

      assert_equal 1, scripts.count
      refute scripts.all? &:valid?
      assert (scripts.all? { |script| script.imported_version == MonitorApp::Application::VERSION.next })

      FileUtils.rm path
    ensure
      ENV.delete 'TEST_VERSION'
    end
  end

  test 'import a script editable' do
    uuid    = SecureRandom.uuid
    tag     = tags :editable
    script  = @script.dup
    scripts = []

    @script.parameters.each { |p| script.parameters << p.dup }
    @script.descriptions.each { |d| script.descriptions << d.dup }

    parameters   = script.parameters.map { |p| p.attributes.slice('name', 'value') }
    descriptions = script.descriptions.map { |d| d.attributes.slice('name', 'value') }

    script.name = 'Should be imported as new'

    script.uuid = uuid
    script.tags << tag

    script.save!

    Current.account = send 'public.accounts', :default
    path            = Script.where(id: script.id).export

    script.destroy!

    assert_difference 'Script.count' do
      scripts = Script.import path
    end

    script_imported = scripts.first

    assert script_imported.is_editable?
  end

  test 'text with db injections' do
    db = send 'public.databases', :postgresql

    assert_equal @script.text, @script.text_with_injections

    @script.text = "ODBC.connect('#{db.name}')"

    # Driver no FreeTDS
    assert_equal @script.text, @script.text_with_injections

    expected = "ODBC.connect('#{db.name}', '#{db.user}', '#{db.password}')\r\n"

    db.update! driver: 'FreeTDS'

    assert_equal expected, @script.text_with_injections

    @script.text = "ODBC.connect('#{db.name}', 'custom_user', 'custom_password')"

    assert_equal @script.text, @script.text_with_injections
  end

  test 'text with ar injections' do
    db = send 'public.databases', :postgresql

    assert_equal @script.text, @script.text_with_injections

    @script.text = "@@ar_connection['#{db.name}']"
    config       = db.ar_config
    expected     = /_ar_connection/

    assert_match expected, @script.text_with_injections
  end

  test 'text with db properties injections' do
    database = send 'public.databases', :postgresql
    property = send 'public.properties', :trace

    assert_equal @script.text, @script.text_with_injections

    @script.text = "puts @@databases['#{database.name}']['#{property.key}']"

    assert_equal "puts '#{property.value}'", @script.text_with_injections
  end

  test 'update from data' do
    skip
  end

  test 'by name' do
    skip
  end

  test 'revert to version' do
    @script.update! change: 'Commit 1', text: 'puts "test"'

    version = @script.versions.last

    @script.update! change: 'Commit 2', text: 'puts "to revert"'

    assert @script.revert_to(version)

    assert_equal(
      I18n.t('scripts.reverts.reverted_from', title: 'Commit 1'),
      @script.reload.change
    )
    assert_equal 'puts "test"', @script.text
  end

  test 'cannot revert to version' do
    @script.paper_trail.save_with_version # generate 1 version

    version = @script.versions.first

    version.object['text'] = nil
    version.save!

    refute @script.revert_to version
  end

  test 'versions with text changes' do
    script = Script.create!(
      name:   'Hello world',
      text:   'puts "Hello world"',
      change: 'Initial'
    )

    assert_difference 'PaperTrail::Version.count' do
      assert_no_difference 'script.versions_with_text_changes.count' do
        script.update! name: 'Super hello world', change: 'change title'
      end
    end

    assert_difference 'script.versions_with_text_changes.count' do
      script.update!(
        name:   'Triple hello world',
        text:   '3.times { puts "Hello world" }',
        change: 'Hello 3'
      )
    end
  end

  test 'correct default version' do
    assert_equal '1.0.0', @script.default_version
  end

  test 'correct current version' do
    assert_equal MonitorApp::Application::VERSION, @script.current_version
  end
end
