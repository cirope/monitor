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

  test 'validates attributes syntax' do
    @script.text = 'def x; true; en'
    error = syntax_errors_for @script.text

    assert @script.invalid?
    assert_error @script, :text, :syntax, errors: error
  end

  test 'validates attributes encoding' do
    @script.text = "\n\t"

    assert @script.invalid?
    assert_error @script, :text, :pdf_encoding
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
    assert_equal @script.name, ActiveSupport::JSON.decode(@script.to_json)['name']
  end

  test 'to pdf' do
    path = @script.to_pdf

    assert File.exist?(path)

    FileUtils.rm path
  end

  test 'export' do
    path = Script.export

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

  test 'import an existing script' do
    path = Script.where(id: @script.id).export

    @script.parameters.clear
    @script.requires.clear
    @script.update! name: 'Updated'

    assert_no_difference 'Script.count' do
      Script.import path
    end

    assert_not_equal 'Updated', @script.reload.name
    assert @script.parameters.any?
    assert @script.requires.any?

    FileUtils.rm path
  end

  test 'import a new script' do
    uuid   = SecureRandom.uuid
    script = @script.dup

    script.name = 'Should be imported as new'
    script.uuid = uuid
    script.save!

    path = Script.where(id: script.id).export

    script.destroy!

    assert_difference 'Script.count' do
      Script.import path
    end

    assert Script.find_by uuid: uuid

    FileUtils.rm path
  end

  test 'text with db injections' do
    db = databases :postgresql

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
    db = databases :postgresql

    assert_equal @script.text, @script.text_with_injections

    @script.text = "@@ar_connection['#{db.name}']"
    config       = db.ar_config
    expected     = "ActiveRecord::Base.establish_connection(#{config})"

    assert_equal expected, @script.text_with_injections
  end

  test 'text with db properties injections' do
    database = databases :postgresql
    property = properties :trace

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
    code   = @script.text
    commit = @script.change

    @script.update! change: 'Commit 1', text: 'ls -l'

    assert_equal 'Commit 1', @script.reload.change
    assert_equal 'ls -l', @script.text

    assert @script.revert_to @script.versions.first

    assert_equal(
      I18n.t('scripts.reverts.reverted_from', title: commit),
      @script.reload.change
    )
    assert_equal code, @script.text
  end

  test 'cannot revert to version' do
    @script.paper_trail.save_with_version # generate 1 version

    version = @script.versions.first

    version.object['name'] = nil
    version.save!

    refute @script.revert_to version
  end


  private

    def syntax_errors_for code
      RequestStore.store[:stderr] = stderr = StringIO.new

      RubyVM::InstructionSequence.compile code

      false
    rescue SyntaxError => ex
      ex.message.lines.concat([stderr.string]).join("\n")
    ensure
      RequestStore.store[:stderr] = STDERR
    end
end
