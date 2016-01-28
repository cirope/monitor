module DashboardHelper
  def dashboard_empty_message
    t filters? ? '.empty_search_html' : '.empty_html'
  end

  def script_issue_count script
    if issue_filter.present?
      issues = script.issues.filter(issue_filter)
      issues = issues.active if issue_filter[:status].blank?

      issues.count
    else
      script.active_issues_count
    end
  end

  def filter_status
    %w(pending taken closed).map { |k| [t("issues.status.#{k}"), k] }
  end
end
