# frozen_string_literal: true

module MenuHelper
  def menu_item_for model, path, active: false
    link     = link_to model.model_name.human(count: 0), path, class: 'nav-link'
    active ||= model.model_name.route_key == controller_name
    options  = if active
                 { class: 'nav-item active' }
               else
                 { class: 'nav-item' }
               end

    content_tag :li, link, options
  end

  def dropdown_item_for model, path
    options = if model.model_name.route_key == controller_name
                { class: 'dropdown-item active' }
              else
                { class: 'dropdown-item' }
              end

    link_to model.model_name.human(count: 0), path, options
  end

  def show_board?
    board_session.present?
  end
end
