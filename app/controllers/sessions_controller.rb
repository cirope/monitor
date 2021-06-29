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
        create_login_record   user
        store_auth_token      user
        store_current_account account

        redirect_to default_url, notice: t('.logged_in', scope: :flash)
      else
        create_failure_record user, params[:username]
        clear_session

        flash.now.alert = t '.invalid', scope: :flash

        render 'new'
      end
    end
  end

  def destroy
    login = Login.find_by id: session[:login_id]

    login&.update! closed_at: Time.zone.now

    clear_session

    redirect_to root_url, notice: t('.logged_out', scope: :flash)
  end

  private

    def default_url
      session.delete(:previous_url) || home_url
    end

    def create_login_record user
      login = user.logins.create! request: request

      session[:login_id] = login.id
    end

    def create_failure_record user, user_name
      Fail.create! user: user, user_name: user_name, request: request
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

      if account
        account.switch { yield account }
      else
        yield nil
      end
    end

    def clear_session
      reset_session
      cookies.delete :token
    end
end
