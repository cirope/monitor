# frozen_string_literal: true

class HomeController < ApplicationController
  include Authentication
  include Issues::Filters
  include CspHeaders::ScriptSrc

  before_action :set_title

  PERMITED_FILTER_PARAMS = [
    :name, :status, :show, :tags, :user_id, :user, :description, :comment
  ]

  def index
    @grouped_by_schedule = group_by_schedule?
    @script_counts       = Kaminari.paginate_array(grouped_issues).page params[:page]
  end

  def api_issues_by_status
    command_token = Api::V1::AuthenticateUser.call Current.user, Current.account

    @token = command_token.success? ? command_token.result : command_token.errors

    @url = api_v1_scripts_issues_by_status_url host: ENV['APP_HOST'],
                                               protocol: ENV['APP_PROTOCOL']
  end

  private

    def issues
      if issue_filter[:status].present? || current_account.group_issues_by_schedule?
        scoped_issues.filter_by issue_filter.except(:name)
      else
        scoped_issues.filter_by(issue_filter.except(:name)).active
      end
    end

    def grouped_issues
      if @grouped_by_schedule
        ScriptOrScheduleWithIssuesViewsDecorator.new(issue_count_by_schedule)
                                                .to_a
      else
        ScriptOrScheduleWithIssuesViewsDecorator.new(issue_count_by_script params[:schedule_id])
                                                .to_a
      end
    end

    def issue_count_by_script schedule_id
      issues.grouped_by_script_and_views(schedule_id, @current_user)
            .ordered_by_script_name
            .count
    end

    def issue_count_by_schedule
      issues.grouped_by_schedule_and_views(@current_user)
            .ordered_by_schedule_name
            .count
    end

    def scoped_issues
      issues = show_mine? ? current_user.issues : Issue.all
      issues = issues.by_script_name filter_params[:name] if filter_params[:name].present?

      issues
    end

    def group_by_schedule?
      params[:schedule_id].blank? && current_account.group_issues_by_schedule?
    end
end
