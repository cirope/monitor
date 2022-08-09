# frozen_string_literal: true

class SessionsController < ApplicationController
  include Sessions

  before_action :authorize, only: :destroy
  before_action :set_title, except: [:destroy]

  def new
    redirect_to default_url if current_user&.visible?
  end

  def create
    if params[:username].present?

      switch_to_default_account_for params[:username] do |account|
        redirect_url = signin_url

        store_username params[:username]

        if account
          store_current_account account

          redirect_url = new_saml_session_url(account.tenant_name) if saml
        end

        redirect_to redirect_url
      end

    else
      flash.now.alert = t '.username_invalid', scope: :flash

      render 'new'
    end
  end

  def destroy
    login = Login.find_by id: session[:login_id]

    login&.update! closed_at: Time.zone.now

    clear_session

    redirect_to root_url, notice: t('.logged_out', scope: :flash)
  end
end
