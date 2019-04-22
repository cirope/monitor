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
end
