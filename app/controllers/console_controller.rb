class ConsoleController < ApplicationController
  respond_to :html

  before_action :authorize, :only_supervisor, :enable?

  def show
  end

  private

    def enable?
      unless ENABLE_WEB_CONSOLE
        redirect_to login_url, alert: t('messages.not_authorized')
      end
    end
end
