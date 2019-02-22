module ApplicationHelper
  def app_name
    ENV['APP_NAME'].presence || I18n.t('app_name')
  end

  def title
    [app_name, current_account&.name, @title].compact.join(' | ')
  end
end
