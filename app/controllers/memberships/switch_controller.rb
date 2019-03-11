# frozen_string_literal: true

class Memberships::SwitchController < ApplicationController
  before_action :authorize
  before_action :set_membership

  def create
    account = @membership.account

    account.switch do
      user = User.find_by! email: @membership.email

      cookies.encrypted[:token] = {
        value:    user.auth_token,
        secure:   Rails.application.config.force_ssl,
        httponly: true
      }
    end

    session[:tenant_name] = account.tenant_name

    redirect_to root_url, notice: t('.notice', account: account.name, scope: :flash)
  end

  private

    def set_membership
      @membership = current_user.memberships.find params[:membership_id]
    end
end
