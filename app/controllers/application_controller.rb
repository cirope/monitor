# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionTitle
  include CacheControl
  include CurrentAccount
  include CurrentUser
  include LdapConfig
  include PdfRender
  include Responder
  include Roles
  include SamlConfig
  include StoreLocation
  include UpdateResource

  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit

  def authorize
    unless current_user&.visible? && current_account
      redirect_to login_url, alert: t('messages.not_authorized')
    end
  end

  def user_for_paper_trail
    current_user&.id
  end
end
