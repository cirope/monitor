class ApplicationController < ActionController::Base
  include ActionTitle
  include CacheControl
  include CurrentUser
  include LdapConfig
  include Responder
  include Roles
  include StoreLocation
  include UpdateResource

  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit

  def authorize
    redirect_to login_url, alert: t('messages.not_authorized') unless current_user
  end

  def user_for_paper_trail
    current_user&.id
  end
end
