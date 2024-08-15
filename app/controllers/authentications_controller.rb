# frozen_string_literal: true

class AuthenticationsController < ApplicationController
  include Sessions

  layout 'public'

  before_action :set_username, :set_title

  def new
    if current_user&.visible?
      redirect_to default_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def create
    switch_to_default_account_for @username do |account|
      user = User.visible.by_username_or_email @username

      if user && account && user.auth(params[:password])
        create_login_record   user
        store_auth_token      user
        store_current_account account
        set_rows_per_page     account

        redirect_to default_url, notice: t('.logged_in', scope: :flash)
      else
        create_fail_record user, @username

        flash.now.alert = t 'invalid', scope: [:flash, :sessions, :create]

        render 'new', status: :unprocessable_entity
      end
    end
  end

  private

    def set_username
      @username = session[:username]
    end
end
