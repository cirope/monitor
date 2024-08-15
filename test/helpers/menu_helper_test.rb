# frozen_string_literal: true

require 'test_helper'

class MenuHelperTest < ActionView::TestCase
  test 'menu item for' do
    link = link_to(
      Rule.model_name.human(count: 0),
      rules_path,
      class: 'side-nav-link'
    )

    assert_equal content_tag(:li, link, class: 'side-nav-item'),
                 menu_item_for(Rule, rules_path)
  end

  test 'dropdown item for' do
    link = link_to(
      User.model_name.human(count: 0),
      users_path,
      class: 'dropdown-item'
    )

    assert_equal link, dropdown_item_for(User, users_path)
  end

  test 'left menu item for' do
    link = link_to User.model_name.human(count: 0), users_path

    assert_equal content_tag(:li, link), left_menu_item_for(User, users_path)
  end

  test 'link to edit profile' do
    assert_match t('profiles.edit.title'), link_to_edit_profile
  end

  test 'is config action' do
    assert is_config_action?

    set_controller_name 'other'

    refute is_config_action?
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

    def controller_name
      @_controller_name || 'servers'
    end

    def set_controller_name name
      @_controller_name = name
    end

    def current_user
      users :franco
    end
end
