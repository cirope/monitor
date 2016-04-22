module Issues::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def issues
    scoped_issues.filter filter_params
  end

  def issue_params
    args = current_user.guest? ? guest_permitted : others_permitted

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
end
