# frozen_string_literal: true

module HomeHelper
  def filter_status
    (Issue.statuses + ['all']).map { |k| [t("issues.status.#{k}"), k] }
  end

  def owner_options
    %w(mine all).map { |k| [t("home.filters.show.#{k}"), k] }
  end

  def filter_query_hash
    issue_filter.to_h.merge show: filter_params[:show],
                            user: filter_params[:user]
  end

  def grouped_issues_path id, options = {}
    if @grouped_by_schedule
      home_path **options.merge(schedule_id: id)
    else
      script_issues_path id, **options
    end
  end

  def link_to_api_issues_by_status
    options = {
      class: 'dropdown-item',
      data:  {
        remote: true,
        method: :get,
        toggle: :dropdown
      }
    }

    link_to home_api_issues_by_status_path, options do
      t 'home.index.api_issues_by_status'
    end
  end
end
