require 'test_helper'

class ResourceStatTest < ActiveSupport::TestCase
  def setup
    @resource_stat = resource_stats :one
  end

  test 'blank attributes' do
    @resource_stat.attr = ''

    assert @resource_stat.invalid?
    assert_error @resource_stat, :attr, :blank
  end

  test 'unique attributes' do
    resource_stat = @resource_stat.dup

    assert resource_stat.invalid?
    assert_error resource_stat, :attr, :taken
  end
end
