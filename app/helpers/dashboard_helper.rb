module DashboardHelper
  def dashboard_empty_message
    t filters? ? '.empty_search_html' : '.empty_html'
  end

  def filter_status
    %w(pending taken closed all).map { |k| [t("issues.status.#{k}"), k] }
  end

  def owner_options
    %w(mine all).map { |k| [t("dashboard.filters.show.#{k}"), k] }
  end

  def filter_query_hash
    issue_filter.to_h.merge show: filter_params[:show],
                            user: filter_params[:user]
  end
end
