# frozen_string_literal: true

class SessionsController < ApplicationController
  include Authentication
  include Sessions

  layout :set_layout

  content_security_policy false

  before_action :authenticate, only: [:destroy]
  before_action :set_title, except: [:destroy]

  def new
    redirect_to default_url if current_user&.visible?
  end

  def create
    if params[:username].present?

      switch_to_default_account_for params[:username] do |account|
        user         = User.visible.by_username_or_email params[:username]
        redirect_url = signin_url

        store_username params[:username]

        if user && account
          store_current_account account

          if saml && !user.recovery?
            redirect_url = new_saml_session_url account.tenant_name
          end
        end

        redirect_to redirect_url
      end

    else
      flash.now.alert = t '.username_invalid', scope: :flash

      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    login = Login.find_by id: session[:login_id]

    login&.update! closed_at: Time.zone.now

    clear_session

    redirect_to root_url, notice: t('.logged_out', scope: :flash)
  end

  private

    def set_layout
      ['new', 'create'].include?(action_name) ? 'public' : 'application'
    end
end
