# frozen_string_literal: true

require 'test_helper'

class LinksHelperTest < ActionView::TestCase
  test 'link to actions' do
    assert_match t('navigation.destroy'), link_to_destroy('#')
    assert_match 'data-method="delete"', link_to_destroy('#')

    assert_match t('navigation.edit'), link_to_edit('#')
    assert_match t('navigation.index'), link_to_index('#')
    assert_match t('navigation.show'), link_to_show('#')
  end

	private

    def current_user
      users :franco
    end

    def controller_path
      Issue
    end
end
