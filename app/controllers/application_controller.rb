# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionTitle
  include CacheControl
  include CurrentAccount
  include CurrentUser
  include LdapConfig
  include PdfRender
  include SamlConfig
  include StoreLocation
  include UpdateResource
  include Authorization

  protect_from_forgery with: :exception

  before_action :set_paper_trail_whodunnit

  def not_authorized_redirect condition
    redirect_to root_url, alert: t('messages.not_authorized') if condition
  end

  def user_for_paper_trail
    current_user&.id
  end
end
