require 'test_helper'

class ExecutionTest < ActiveSupport::TestCase
  def setup
    @execution = executions :one
  end

  test 'blank attributes' do
    @execution.attr = ''

    assert @execution.invalid?
    assert_error @execution, :attr, :blank
  end

  test 'unique attributes' do
    execution = @execution.dup

    assert execution.invalid?
    assert_error execution, :attr, :taken
  end
end
