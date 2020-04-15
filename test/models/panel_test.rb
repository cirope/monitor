# frozen_string_literal: true

require 'test_helper'

class PanelTest < ActiveSupport::TestCase
  setup do
    @panel = panels :servers_overloaded
  end

  test 'blank attributes' do
    @panel.title = ''
    @panel.height = nil
    @panel.width = nil
    @panel.function = ''
    @panel.output_type = ''

    assert @panel.invalid?
    assert_error @panel, :title, :blank
    assert_error @panel, :height, :blank
    assert_error @panel, :width, :blank
    assert_error @panel, :function, :blank
    assert_error @panel, :output_type, :blank
  end

  test 'unique attributes' do
    panel = @panel.dup

    assert panel.invalid?
    assert_error panel, :title, :taken
  end

  test 'attributes length' do
    @panel.title = 'abcde' * 52

    assert @panel.invalid?
    assert_error @panel, :title, :too_long, count: 255
  end

  test 'attributes boundaries' do
    @panel.height = 0
    @panel.width  = 0

    assert @panel.invalid?
    assert_error @panel, :height, :greater_than, count: 0
    assert_error @panel, :width, :greater_than, count: 0

    @panel.height = 4
    @panel.width  = 4

    assert @panel.invalid?
    assert_error @panel, :height, :less_than, count: 4
    assert_error @panel, :width, :less_than, count: 4
  end
end
