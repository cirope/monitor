# frozen_string_literal: true

module Issues::Filters
  extend ActiveSupport::Concern

  PERMITED_FILTER_PARAMS = [
    :id,
    :description,
    :status,
    :user,
    :user_id,
    :show,
    :tags,
    :data,
    :comment,
    :created_at
  ]

  included do
    helper_method :filter_params
  end

  def issues
    scoped_issues.filter_by filter_params.except(:show, :user)
  end

  def issue_params
    args = @issue.can_be_edited_by?(current_user) ? editors_params : guest_params

    params.require(:issue).permit(*args)
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit *PERMITED_FILTER_PARAMS
    else
      {}
    end
  end

  def filter_default_status?
    filter_params[:status].present?
  end

  def show_mine?
    mine_by_user_role = current_user.guest? || current_user.security?
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
        :status, :description,
          subscriptions_attributes: [:id, :user_id, :_destroy],
          comments_attributes: [:id, :text, :file, :file_cache],
          taggings_attributes: [:id, :tag_id, :_destroy]
      ]
    end

    def guest_params
      [
        comments_attributes: [:id, :text, :file, :file_cache]
      ]
    end
end
