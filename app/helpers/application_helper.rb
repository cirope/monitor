module ApplicationHelper
  def app_name
    ENV['APP_NAME'].present? ? ENV['APP_NAME'] : I18n.t('app_name')
  end

  def title
    [app_name, @title].compact.join(' | ')
  end
end
