# frozen_string_literal: true

module Issues::Filters
  extend ActiveSupport::Concern

  PERMITED_FILTER_PARAMS = [
    :id,
    :name,
    :title,
    :description,
    :status,
    :user,
    :user_id,
    :show,
    :tags,
    :data,
    :comment,
    :key,
    :created_at,
    :scheduled_at,
    { canonical_data: {} }
  ]

  included do
    helper_method :filter_params
    helper_method :issue_filter
  end

  def issues
    scoped_issues.filter_by filter_params.except(:name, :show, :user)
  end

  def issue_params
    args = if @issue.blank? || @issue.can_be_edited_by?(current_user)
             editors_params
           elsif current_user.owner?
             owner_params
           else
             guest_params
           end

    params.require(:issue).permit *args
  end

  def issue_filter
    filter_params.slice :status, :tags, :description, :key, :user_id, :comment, :canonical_data
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit *PERMITED_FILTER_PARAMS
    else
      {}
    end
  end

  def skip_default_status?
    filter_params[:status].present? || current_account.group_issues_by_schedule?
  end

  def show_mine?
    mine_by_user_role = !current_user.can_use_mine_filter?
    show_all          = filter_params[:show] == 'all'
    on_board          = controller_name == 'board'
    filter_id         = filter_params[:id]
    on_board_create   = on_board && action_name == 'create' && !filter_id && !show_all
    on_index_action   = action_name == 'index' && !show_all

    mine_by_user_role || on_board_create || (on_index_action && !on_board)
  end

  private

    def scoped_issues
      if @permalink
        @permalink.issues
      elsif @script
        _issues.script_scoped(@script)
      else
        _issues
      end
    end

    def _issues
      show_mine? ? current_user.issues : Issue.all
    end

    def editors_params
      [
        :status, :title, :description, :owner_type,
          subscriptions_attributes: [:id, :user_id, :_destroy],
          comments_attributes: [:id, :text, :attachment],
          taggings_attributes: [:id, :tag_id, :_destroy]
      ]
    end

    def owner_params
      [
        :status, comments_attributes: [:id, :text, :attachment]
      ]
    end

    def guest_params
      [
        comments_attributes: [:id, :text, :attachment]
      ]
    end
end
