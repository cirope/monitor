# frozen_string_literal: true

class AuthenticationsController < ApplicationController
  include Sessions

  before_action :set_user, :set_account, :set_title

  def new
    if current_user&.visible?
      redirect_to default_url
    elsif @user && @account
      render 'new'
    else
      create_fail_record @user, params[:username]
      clear_session

      redirect_to login_url, alert: t('sessions.create.invalid', scope: :flash)
    end
  end

  def create
    if @user && @account && @user.auth(params[:password])
      create_login_record   @user
      store_auth_token      @user

      redirect_to default_url, notice: t('.logged_in', scope: :flash)
    else
      create_fail_record @user, params[:username]

      flash.now.alert = t '.invalid', scope: :flash

      render 'new'
    end
  end

  private

    def set_user
      @user = User.find_by id: session[:current_user_id]
    end

    def set_account
      @account = Account.find_by tenant_name: session[:tenant_name]
    end

    def create_login_record user
      login = user.logins.create! request: request

      session[:login_id] = login.id
    end

    def store_auth_token user
      jar = params[:remember_me] ? cookies.permanent : cookies

      jar.encrypted[:token] = {
        value:    user.auth_token,
        secure:   Rails.application.config.force_ssl,
        httponly: true
      }
    end
end
