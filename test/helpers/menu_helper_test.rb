require 'test_helper'

class MenuHelperTest < ActionView::TestCase
  test 'menu item for' do
    link = link_to User.model_name.human(count: 0), users_path

    assert_equal content_tag(:li, link), menu_item_for(User, users_path)
  end

  test 'show board?' do
    assert !show_board?

    session[:board_issues] = [issues(:ls_on_atahualpa_not_well).id]

    assert show_board?
  end
end
