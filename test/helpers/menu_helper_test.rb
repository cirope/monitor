# frozen_string_literal: true

require 'test_helper'

class MenuHelperTest < ActionView::TestCase
  test 'menu item for' do
    link = link_to(
      User.model_name.human(count: 0),
      users_path,
      class: 'nav-link'
    )

    assert_equal content_tag(:li, link, class: 'nav-item'),
                 menu_item_for(User, users_path)
  end

  test 'dropdown item for' do
    link = link_to(
      User.model_name.human(count: 0),
      users_path,
      class: 'dropdown-item'
    )

    assert_equal link, dropdown_item_for(User, users_path)
  end

  test 'show board?' do
    assert !show_board?

    session[:board_issues] = [issues(:ls_on_atahualpa_not_well).id]

    assert show_board?
  end

  private

    def board_session
      session[:board_issues] ||= []
    end
end
