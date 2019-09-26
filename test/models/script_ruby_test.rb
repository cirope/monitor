# frozen_string_literal: true

require 'test_helper'

class ScriptRubyTest < ActiveSupport::TestCase
  setup do
    @script = scripts :ls
  end

  teardown do
    Current.account = nil
  end

  test 'validates attributes syntax' do
    @script.text = 'def x; true; en'
    error = syntax_errors_for @script.text

    assert @script.invalid?
    assert_error @script, :text, :syntax, errors: error
  end

  test 'body dependencies (inclusions)' do
    script = scripts :cd_root
    body   = @script.body

    assert_match script.text, body
    assert_match @script.text, body
  end

  test 'body includes defaults' do
    Script.create! name: 'Core test', core: true, text: 'puts "Core script"', change: 'Initial'

    assert_match 'Core script', @script.body
  end

  private

    def syntax_errors_for code
      RequestStore.store[:stderr] = stderr = StringIO.new

      RubyVM::InstructionSequence.compile code

      false
    rescue SyntaxError => ex
      ex.message.lines.concat([stderr.string]).join "\n"
    ensure
      RequestStore.store[:stderr] = STDERR
    end
end
