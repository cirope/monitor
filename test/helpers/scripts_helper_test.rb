# frozen_string_literal: true

require 'test_helper'

class ScriptsHelperTest < ActionView::TestCase
  test 'script maintainers' do
    @script = scripts :ls

    assert_equal @script.maintainers, maintainers

    @script = Script.new

    assert_equal 1, maintainers.size
    assert maintainers.all?(&:new_record?)
  end

  test 'script requires' do
    @script = scripts :ls

    assert_equal @script.requires, requires

    @script = Script.new

    assert_equal 1, requires.size
    assert requires.all?(&:new_record?)
  end

  test 'script taggings' do
    @script = scripts :ls

    assert_equal @script.taggings, script_taggings

    @script = Script.new

    assert_equal 1, script_taggings.size
    assert script_taggings.all?(&:new_record?)
  end

  test 'script parameters' do
    @script = scripts :ls

    assert_equal @script.parameters, parameters

    @script = Script.new

    assert_equal 1, parameters.size
    assert parameters.all?(&:new_record?)
  end

  test 'script descriptions' do
    @script = scripts :ls

    assert_equal @script.descriptions, descriptions

    @script = Script.new

    assert_equal 1, descriptions.size
    assert descriptions.all?(&:new_record?)
  end

  test 'file identifier' do
    skip
  end

  test 'disable edition' do
    @script = scripts :ls

    assert !disable_edition?

    @script.imported_at = Time.zone.now

    assert disable_edition?
  end

  test 'enable edition when is imported' do
    @script = scripts :ls

    @script.imported_at = Time.zone.now
    @script.imported_as = 'read_only'

    assert disable_edition?

    @script.imported_at = Time.zone.now
    @script.imported_as = 'editable'

    refute disable_edition?
  end

  test 'imported tag' do
    skip
  end

  test 'last change diff' do
    @script = scripts :ls

    assert_kind_of String, last_change_diff
  end

  test 'link to execute' do
    @server       = servers :atahualpa
    @script       = scripts :ls
    @virtual_path = 'scripts.show'

    assert_match t('.execute_now'), link_to_execute
  end

  test 'disabled link to execute' do
    @script       = scripts :ls
    @virtual_path = 'scripts.show'

    assert_match t('.no_server'), link_to_execute
  end

  test 'lang icon' do
    ruby  = scripts :ls
    shell = scripts :pwd

    assert_match 'fas fa-gem', lang_icon(ruby)
    assert_match 'fas fa-hashtag', lang_icon(shell)
  end

  test 'imported status' do
    script                 = scripts :ls
    script.imported_status = 'created'

    assert_match 'bg-success', show_script_imported_status(script)

    script.imported_status = 'updated'

    assert_match 'bg-warning', show_script_imported_status(script)
  end
end
