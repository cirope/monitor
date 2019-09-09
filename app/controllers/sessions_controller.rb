# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :authorize, only: :destroy
  before_action :set_title, except: [:destroy]

  def new
    redirect_to default_url if current_user&.visible?
  end

  def create
    switch_to_default_account_for params[:username] do |account|
      user = User.visible.by_username_or_email params[:username]

      if user && account && user.auth(params[:password])
        store_auth_token      user
        store_current_account account

        redirect_to default_url, notice: t('.logged_in', scope: :flash)
      else
        flash.now.alert = t '.invalid', scope: :flash

        render 'new'
      end
    end
  end

  def destroy
    reset_session
    cookies.delete :token

    redirect_to root_url, notice: t('.logged_out', scope: :flash)
  end

  private

    def default_url
      session.delete(:previous_url) || dashboard_url
    end

    def store_auth_token user
      jar = params[:remember_me] ? cookies.permanent : cookies

      jar.encrypted[:token] = {
        value:    user.auth_token,
        secure:   Rails.application.config.force_ssl,
        httponly: true
      }
    end

    def store_current_account account
      session[:tenant_name] = account.tenant_name
    end

    def switch_to_default_account_for username
      account = Account.default_by_username_or_email username

      account&.switch { yield account }
    end
end
