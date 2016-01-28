module Issues::Filters
  extend ActiveSupport::Concern

  included do
    helper_method :filter_params
  end

  def issues
    issues = scoped_issues
    issues = issues.active if filter_params[:status].blank?

    issues.filter(filter_params)
  end

  def issue_params
    args = current_user.guest? ? guest_permitted : others_permitted

    params.require(:issue).permit(*args)
  end

  def filter_params
    params[:filter].present? ?
      params.require(:filter).permit(:description, :status, :tags) :
      {}
  end

  private

    def scoped_issues
      if current_user.guest?
        current_user.issues
      else
        @script ? Issue.script_scoped(@script) : Issue.all
      end
    end
end
