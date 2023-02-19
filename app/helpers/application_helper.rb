# frozen_string_literal: true

module ApplicationHelper
  def app_name
    I18n.t 'app_name'
  end

  def title
    [app_name, current_account&.name, @title].compact.join ' | '
  end

  def logo_title
    [current_account&.name, MonitorApp::Application::VERSION].compact.join ' | '
  end

  def show_boolean_badge field
    if field
      badge = 'success'
      text  = t 'navigation._yes'
    else
      badge = 'danger'
      text  = t 'navigation._no'
    end

    content_tag :span, text, class: "badge bg-#{badge}"
  end
end
