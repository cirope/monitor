# frozen_string_literal: true

module ApplicationHelper
  def app_name
    I18n.t 'app_name'
  end

  def title
    [app_name, current_account&.name, @title].compact.join(' | ')
  end
end
