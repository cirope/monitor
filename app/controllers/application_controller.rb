class ApplicationController < ActionController::Base
  include ActionTitle
  include CurrentUser
  include UpdateResource

  protect_from_forgery with: :exception

  def authorize
    redirect_to login_url, alert: t('messages.not_authorized') unless current_user
  end

  def not_guest
    redirect_to issues_url, alert: t('messages.not_authorized') if current_user.guest?
  end

  def user_for_paper_trail
    current_user.try :id
  end
end
