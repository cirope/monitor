# frozen_string_literal: true

require 'test_helper'

class RuleTest < ActiveSupport::TestCase
  setup do
    @rule = rules :cd_email
  end

  test 'blank attributes' do
    @rule.name = ''

    assert @rule.invalid?
    assert_error @rule, :name, :blank
  end

  test 'search' do
    rules = Rule.search query: @rule.name

    assert rules.present?
    assert rules.all? { |s| s.name =~ /#{@rule.name}/ }
  end

  test 'by name' do
    skip
  end

  test 'to json' do
    assert_equal @rule.name, ActiveSupport::JSON.decode(@rule.to_json)['name']
  end

  test 'export' do
    path = Rule.export

    assert File.exist?(path)

    FileUtils.rm path
  end

  test 'add to zip' do
    zipfile_path      = "#{SecureRandom.uuid}.zip"
    expected_filename = "#{@rule.uuid}.json"

    ::Zip::File.open zipfile_path, Zip::File::CREATE do |zipfile|
      assert !zipfile.find_entry(expected_filename)

      @rule.add_to_zip zipfile

      assert zipfile.find_entry(expected_filename)
    end

    FileUtils.rm zipfile_path
  end

  test 'import an existing rule' do
    uuid    = SecureRandom.uuid
    trigger = @rule.triggers.create! uuid: uuid, callback: 'puts "to remove and restore"'
    path    = Rule.where(id: @rule.id).export

    trigger.destroy!
    @rule.update! name: 'Updated'

    assert_no_difference 'Rule.count' do
      Rule.import path
    end

    assert_not_equal 'Updated', @rule.reload.name
    assert @rule.triggers.where(uuid: uuid).exists?

    FileUtils.rm path
  end

  test 'import a new rule' do
    uuid = SecureRandom.uuid
    rule = @rule.dup

    rule.name = 'Should be imported as new'
    rule.uuid = uuid
    rule.save!

    path = Rule.where(id: rule.id).export

    rule.destroy!

    assert_difference 'Rule.count' do
      Rule.import path
    end

    assert Rule.find_by uuid: uuid

    FileUtils.rm path
  end
end
