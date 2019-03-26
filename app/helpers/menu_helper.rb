# frozen_string_literal: true

module MenuHelper
  def menu_item_for model, path, show_active = false
    link = link_to model.model_name.human(count: 0), path
    active = show_active || model.model_name.route_key == controller_name

    content_tag(:li, link, (active ? { class: 'active' } : {}))
  end

  def show_board?
    board_session.present?
  end
end
