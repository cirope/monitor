class SessionsController < ApplicationController
  before_action :authorize, only: :destroy
  before_action :set_title, except: [:destroy]

  def new
    redirect_to default_url if current_user
  end

  def create
    user = User.visible.by_username_or_email params[:username]

    if user && user.auth(params[:password])
      store_auth_token user

      redirect_to default_url, notice: t('.logged_in', scope: :flash)
    else
      flash.now.alert = t '.invalid', scope: :flash

      render 'new'
    end
  end

  def destroy
    reset_session
    cookies.delete :auth_token

    redirect_to root_url, notice: t('.logged_out', scope: :flash)
  end

  private

    def default_url
      session.delete(:previous_url) || dashboard_url
    end

    def store_auth_token user
      if params[:remember_me]
        cookies.permanent.encrypted[:auth_token] = user.auth_token
      else
        cookies.encrypted[:auth_token] = user.auth_token
      end
    end
end
