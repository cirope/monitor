module DashboardHelper
  def filters?
    filters = params[:filter]

    filters && filters.values.any?(&:present?)
  end

  def dashboard_empty_message
    t filters? ? '.empty_search_html' : '.empty_html'
  end

  def script_issue_count script
    if issue_filter.present?
      script.issues.filter(issue_filter).count
    else
      script.active_issues_count
    end
  end

  def filter_status
    %w(pending taken closed).map { |k| [t("issues.status.#{k}"), k] }
  end
end
