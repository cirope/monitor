module Issues::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def issues
    scoped_issues.filter filter_params
  end

  def issue_params
    args = @issue.can_be_edited_by?(current_user) ? editors_params : guest_params

    params.require(:issue).permit(*args)
  end

  def filter_params
    if params[:filter].present?
      params.require(:filter).permit :id, :description, :status, :tags, :data, :created_at
    else
      {}
    end
  end

  def filter_default_status?
    filter_params[:status].present?
  end

  private

    def scoped_issues
      if @permalink
        @permalink.issues
      elsif current_user.guest? || current_user.security?
        current_user.issues
      else
        @script ? Issue.script_scoped(@script) : Issue.all
      end
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
