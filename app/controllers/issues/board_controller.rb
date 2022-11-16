# frozen_string_literal: true

class Issues::BoardController < ApplicationController
  include Issues::Filters

  before_action :authorize, :not_guest, :not_owner
  before_action :only_supervisor, only: [:destroy_all]
  before_action :set_title, only: [:index]
  before_action :set_issue,  only: [:create, :destroy]
  before_action :set_script, only: [:create, :destroy]

  def index
    @issues = issues.order(:created_at).where id: board_session
    @issues = @issues.page params[:page] unless skip_page?

    respond_to do |format|
      format.pdf { render_pdf @issues }
      format.any(:html, :js, :csv)
    end
  end

  def create
    @issues   = skip_default_status? || @issue ? issues : issues.active
    @template = params[:partial] == 'alt' ? 'issue_alt' : 'issue'

    board_session.concat(@issues.pluck('id')).uniq!

    redirect_back(fallback_location: root_url) unless request.xhr?
  end

  def update
    filtered_issues = issues.where id: board_session

    board_session_errors.clear

    update_issues filtered_issues

    if board_session_errors.empty?
      redirect_to issues_board_url, notice: t('.updated')
    else
      redirect_to issues_board_url, alert: t('.fail')
    end
  end

  def destroy
    @issues   = skip_default_status? || @issue ? issues : issues.active
    @template = params[:partial] == 'alt' ? 'issue_alt' : 'issue'

    @issues.each { |issue| board_session.delete issue.id }

    redirect_back fallback_location: root_url unless request.xhr?
  end

  def empty
    board_session.clear
    board_session_errors.clear

    redirect_to home_url, notice: t('.done')
  end

  def destroy_all
    issues.where(id: board_session).destroy_all

    board_session.clear
    board_session_errors.clear

    redirect_to home_url, notice: t('.destroyed')
  end

  private

    def set_issue
      @issue = issues.find filter_params[:id] if filter_params[:id]
    end

    def set_script
      @script = Script.find params[:script_id] if params[:script_id]
    end

    def issue_params
      permit = [
        :status,
        :group_comments_email,
        comments_attributes:      [:text, :attachment],
        taggings_attributes:      [:tag_id],
        subscriptions_attributes: [:user_id]
      ]

      permit = [:description] + permit if current_user.supervisor?

      params.require(:issue).permit *permit
    end

    def board_session
      session[:board_issues] ||= []
    end

    def board_session_errors
      session[:board_issue_errors] ||= {}
    end

    def update_issues issues
      issue_attrs         = issue_params.select { |_, value| value.present? }
      remove_tags         = remove_tags? issue_attrs
      comments_attributes = group_comments_attributes issue_attrs

      issues.find_each do |issue|
        update_issue issue, issue_attrs, remove_previous_tags: remove_tags
      end

      issues.comment comments_attributes.values.first if comments_attributes
    end

    def update_issue issue, issue_params, remove_previous_tags:
      Issue.transaction do
        issue.taggings.clear if remove_previous_tags

        unless issue.update issue_params
          board_session_errors[issue.id] = issue.errors.full_messages

          raise ActiveRecord::Rollback
        end
      end
    end

    def group_comments_attributes issue_attrs
      group_comments_email = issue_attrs.delete :group_comments_email

      if group_comments_email == '1' || group_comments_email == true
        comments_attributes = issue_attrs.delete :comments_attributes
      end
    end

    def remove_tags? issue_attrs
      taggings_attributes  = issue_attrs.fetch :taggings_attributes, {}
      tags                 = taggings_attributes.select do |index, tagging|
        tagging[:tag_id].present?
      end

      tags.present?
    end

    def skip_page?
      %i(csv pdf).include? request.format.symbol
    end
end
