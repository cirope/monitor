# frozen_string_literal: true

module MenuHelper
  def menu_item_for model, path, active: false, icon: nil
    if current_user.can? :read, model
      active     ||= model.model_name.route_key == controller_name
      link_class   = 'side-nav-link'
      li_class     = 'side-nav-item'
      link_text    = model.model_name.human count: 0
      link_text    = icon ? raw([icon('fas', icon), link_text].join) : link_text

      if active
        link_class += ' active'
        li_class   += ' menuitem-active'
      end

      content_tag :li, link_to(link_text, path, class: link_class), class: li_class
    end
  end

  def dropdown_item_for model, path
    if current_user.can? :read, model
      options = if model.model_name.route_key == controller_name
                  { class: 'dropdown-item active' }
                else
                  { class: 'dropdown-item' }
                end

      link_to model.model_name.human(count: 0), path, options
    end
  end

  def left_menu_item_for model, path
    if current_user.can? :read, model
      link    = left_menu_link_for model, path
      options = if model.model_name.route_key == controller_name
                  { class: 'menuitem-active' }
                else
                  {}
                end

      content_tag :li, link, options
    end
  end

  def is_config_action?
    Permission.config.any? do |model|
      model.constantize.model_name.route_key == controller_name
    end
  end

  def link_to_edit_profile
    options = if controller_name == 'profiles'
                { class: 'dropdown-item active' }
              else
                { class: 'dropdown-item' }
              end

    link_to t('profiles.edit.title'), profile_path, options
  end

  def link_to_logout
    options = {
      class: 'dropdown-item',
      data:  { method: :delete }
    }

    link_to t('navigation.logout'), logout_path, options
  end

  def show_board?
    board_session.present?
  end

  private

    def left_menu_link_for model, path
      options = if model.model_name.route_key == controller_name
                  { class: 'active' }
                else
                  {}
                end

      link_to model.model_name.human(count: 0), path, options
    end
end
