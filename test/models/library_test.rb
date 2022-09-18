# frozen_string_literal: true

require 'test_helper'

class LibraryTest < ActiveSupport::TestCase
  setup do
    @library = libraries :net_smtp
  end

  test 'blank attributes' do
    @library.name = ''

    assert @library.invalid?
    assert_error @library, :name, :blank
  end

  test 'attributes length' do
    @library.name = 'abcde' * 52

    assert @library.invalid?
    assert_error @library, :name, :too_long, count: 255
  end

  test 'unique attributes' do
    library = @library.dup

    assert library.invalid?
    assert_error library, :name, :taken
  end
end
