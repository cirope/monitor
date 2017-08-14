require 'test_helper'

class TriggerTest < ActiveSupport::TestCase
  setup do
    @trigger = triggers :email
  end

  test 'blank attributes' do
    @trigger.callback = ''

    assert @trigger.invalid?
    assert_error @trigger, :callback, :blank
  end

  test 'validates attributes syntax' do
    @trigger.callback = 'def x; true; en'
    error = syntax_errors_for @trigger.callback

    assert @trigger.invalid?
    assert_error @trigger, :callback, :syntax, errors: error
  end

  test 'validates attributes encoding' do
    @trigger.callback = "\n\t"

    assert @trigger.invalid?
    assert_error @trigger, :callback, :pdf_encoding
  end

  test 'run on' do
    skip
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
