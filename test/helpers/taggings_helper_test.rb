# frozen_string_literal: true

require 'test_helper'

class TaggingsHelperTest < ActionView::TestCase
  test 'tagging tags' do
    parent = tags :important
    child  = tags :final

    child.update! parent: parent

    assert_equal [[child.name, child.id]], tagging_tags(parent.name)
  end

  test 'issue tag kind' do
    issue = issues :ls_on_atahualpa_not_well

    issue_kind = issue_tag_kind issue

    assert_equal 'issue', issue_kind

    ticket = tickets :ticket_script

    ticket_kind = issue_tag_kind ticket

    assert_equal 'ticket', ticket_kind

    param_nil = issue_tag_kind nil

    assert_equal 'issue', param_nil
  end
end
