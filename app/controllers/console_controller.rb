# frozen_string_literal: true

class ConsoleController < ApplicationController
  include Authorization

  before_action :enable?

  def show
  end

  private

    def enable?
      unless ENABLE_WEB_CONSOLE
        redirect_to login_url, alert: t('messages.not_authorized')
      end
    end
end
