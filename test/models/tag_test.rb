# frozen_string_literal: true

require 'test_helper'

class TagTest < ActiveSupport::TestCase
  setup do
    @tag = tags :starters
  end

  test 'blank attributes' do
    @tag.name = ''
    @tag.kind = ''
    @tag.style = ''

    assert @tag.invalid?
    assert_error @tag, :name, :blank
    assert_error @tag, :kind, :blank
    assert_error @tag, :style, :blank
  end

  test 'unique attributes' do
    tag = @tag.dup

    assert tag.invalid?
    assert_error tag, :name, :taken
  end

  test 'attributes length' do
    @tag.name = 'abcde' * 52
    @tag.kind = 'abcde' * 52
    @tag.style = 'abcde' * 52

    assert @tag.invalid?
    assert_error @tag, :name, :too_long, count: 255
    assert_error @tag, :kind, :too_long, count: 255
    assert_error @tag, :style, :too_long, count: 255
  end

  test 'attributes inclusion' do
    @tag.kind = 'wrong'
    @tag.style = 'wrong'

    assert @tag.invalid?
    assert_error @tag, :kind, :inclusion
    assert_error @tag, :style, :inclusion
  end

  test 'can not destroy when final and has taggables' do
    tag   = tags :final
    issue = issues :ls_on_atahualpa_not_well

    issue.taggings.create! tag_id: tag.id

    assert_no_difference 'Tag.count' do
      tag.destroy
    end
  end

  test 'use effects' do
    refute @tag.use_effects?

    @tag.kind = 'issue'

    assert @tag.use_effects?
  end

  test 'use parent' do
    refute @tag.use_parent?

    @tag.kind = 'issue'

    assert @tag.use_parent?
  end

  test 'search' do
    tags = Tag.search query: @tag.name

    assert tags.any?
    assert tags.all? { |s| s.name =~ /#{@tag.name}/ }
  end

  test 'export' do
    tags = Tag.export true

    assert tags.any?
    assert tags.all?(&:export?)
  end

  test 'final' do
    tags = Tag.final true

    assert tags.any?
    assert tags.all?(&:final?)
  end

  test 'group option' do
    tags = Tag.group_option true

    assert tags.any?
    assert tags.all?(&:group?)
  end

  test 'by issues' do
    skip
  end
end
