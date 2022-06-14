# frozen_string_literal: true

class SessionsController < ApplicationController
  include Sessions

  before_action :authorize, only: :destroy
  before_action :set_title, except: [:destroy]

  def new
    redirect_to default_url if current_user&.visible?
  end

  def create
    switch_to_default_account_for params[:username] do |account|
      user = User.visible.by_username_or_email params[:username]

      if user && account
        store_current_user user
        store_current_account account

        redirect_to signin_url
      else
        create_fail_record user, params[:username]
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
end
