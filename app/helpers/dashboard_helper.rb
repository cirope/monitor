module DashboardHelper
  def dashboard_empty_message
    t filters? ? '.empty_search_html' : '.empty_html'
  end

  def filter_status
    %w(pending taken closed all).map { |k| [t("issues.status.#{k}"), k] }
  end
end
