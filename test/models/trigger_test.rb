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

  test 'code attributes' do
    @trigger.callback = 'def x; true; en'
    error = syntax_errors_for @trigger.callback

    assert @trigger.invalid?
    assert_error @trigger, :callback, :syntax, errors: error
  end

  test 'run on' do
    skip
  end

  private

    def syntax_errors_for code
      RubyVM::InstructionSequence.compile code

      false
    rescue SyntaxError => ex
      ex.message.lines.first.chomp
    end
end
