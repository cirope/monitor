module Authenticate
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  def authenticate
    unless current_user&.visible? && current_account
      redirect_to login_url, alert: t('messages.not_authorized')
    end
  end
end
