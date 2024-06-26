# frozen_string_literal: true

class Memberships::SwitchController < ApplicationController
  include Authentication
  include Sessions

  before_action :set_membership

  def create
    account = @membership.account

    clear_session

    account.switch do
      user = User.find_by! email: @membership.email
      store_username user.username

      if saml
        redirect_to new_saml_session_url(account.tenant_name)
      else
        cookies.encrypted[:token] = user.auth_token

        store_current_account account
        set_rows_per_page     account

        redirect_to root_url, notice: t('.notice', account: account.name, scope: :flash)
      end
    end
  end

  private

    def set_membership
      @membership = current_user.memberships.find params[:membership_id]
    end
end
