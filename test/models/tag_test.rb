require 'test_helper'

class TagTest < ActiveSupport::TestCase
  def setup
    @tag = tags :starters
  end

  test 'blank attributes' do
    @tag.name = ''

    assert @tag.invalid?
    assert_error @tag, :name, :blank
  end

  test 'unique attributes' do
    tag = @tag.dup

    assert tag.invalid?
    assert_error tag, :name, :taken
  end

  test 'attributes length' do
    @tag.name = 'abcde' * 52

    assert @tag.invalid?
    assert_error @tag, :name, :too_long, count: 255
  end

  test 'search' do
    tags = Tag.search query: @tag.name

    assert tags.present?
    assert tags.all? { |s| s.name =~ /#{@tag.name}/ }
  end
end
