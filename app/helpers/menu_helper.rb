# frozen_string_literal: true

module MenuHelper
  def menu_item_for model, path, active: false, icon: nil
    active     ||= model.model_name.route_key == controller_name
    link_class   = 'side-nav-link'
    li_class     = 'side-nav-item'
    link_text    = model.model_name.human count: 0
    link_text    = icon ? raw([icon('fas', icon), link_text].join) : link_text

    if active
      link_class += ' active'
      li_class   += ' mm-active'
    end

    content_tag :li, link_to(link_text, path, class: link_class), class: li_class
  end

  def dropdown_item_for model, path
    options = if model.model_name.route_key == controller_name
                { class: 'dropdown-item active' }
              else
                { class: 'dropdown-item' }
              end

    link_to model.model_name.human(count: 0), path, options
  end

  def left_menu_item_for model, path
    link    = left_menu_link_for model, path
    options = if model.model_name.route_key == controller_name
                { class: 'mm-active' }
              else
                {}
              end

    content_tag :li, link, options
  end

  def is_config_action?
    models = [
      User,
      Tag,
      Descriptor,
      Account,
      Server,
      Database,
      Ldap,
      console_helper_model,
      processes_helper_model
    ]

    models.any? do |model|
      model.model_name.route_key == controller_name
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

  def show_board?
    board_session.present?
  end

  def console_helper_model
    model_name = OpenStruct.new route_key: 'console'
    model      = OpenStruct.new model_name: model_name

    def model_name.human _options
      I18n.t 'console.show.title'
    end

    model
  end

  def processes_helper_model
    model_name = OpenStruct.new route_key: 'processes'
    model      = OpenStruct.new model_name: model_name

    def model_name.human _options
      I18n.t 'processes.index.title'
    end

    model
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
