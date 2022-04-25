# frozen_string_literal: true

require 'test_helper'

class TagsHelperTest < ActionView::TestCase
  test 'tag_kinds' do
    assert_respond_to tag_kinds, :each
  end

  test 'styles' do
    assert_respond_to styles, :each
  end

  test 'tag icons' do
    tags   = scripts(:cd_root).tags
    result = tag_icons tags

    assert_match tags.first.name, result
  end

  test 'parent tag path' do
    tag = tags :important

    assert_match tag.id.to_s, parent_tags_path(tag)
  end

  test 'limited tag form edition for' do
    assert unlimited_tag_form_edition_for?('user')

    assert !unlimited_tag_form_edition_for?('issue')

    @allow_edit = true

    assert unlimited_tag_form_edition_for?('issue')
  end

  test 'tag effects' do
    @tag = tags :important

    assert_equal @tag.effects, effects

    @tag = Tag.new

    assert_equal 1, effects.size
    assert effects.all?(&:new_record?)
  end

  private

    def limited_issue_form_edition?
      !@allow_edit
    end

    def limited_issue_tag_form_edition?
      @allow_edit
    end
end
