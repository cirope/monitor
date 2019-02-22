class PasswordResetsController < ApplicationController
  before_action :set_title, except: [:destroy]
  before_action :set_account, only: [:edit]
  before_action :set_user, only: [:edit, :update]

  def new
  end

  def create
    membership = Membership.default.find_by email: params[:email]

    if membership
      Apartment::Tenant.switch membership.account.tenant_name do
        user = membership.user

        user.prepare_password_reset
        UserMailer.password_reset(user).deliver_later

        redirect_to root_url, notice: t('.notice', scope: :flash)
      end
    else
      flash.now[:alert] = t '.not_found', scope: :flash

      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.password_expired?
      redirect_to new_password_reset_path, alert: t('.expired', scope: :flash)
    elsif @user.update(user_params)
      redirect_to root_url, notice: t('.notice', scope: :flash)
    else
      render 'edit'
    end
  end

  private

    def set_user
      @user = User.find_by! password_reset_token: params[:id]
    end

    def set_account
      if params[:account_id]
        account = Account.find_by! tenant_name: params[:account_id]

        Apartment::Tenant.switch(account.tenant_name) { set_user }

        session[:tenant_name] = account.tenant_name

        redirect_to edit_password_reset_url(@user.password_reset_token)
      end
    end

    def user_params
      params.require(:user).permit :password, :password_confirmation
    end
end
