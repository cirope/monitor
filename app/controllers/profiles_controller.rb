class ProfilesController < ApplicationController
  before_action :authorize, :set_user, :set_title

  def edit
  end

  def update
    respond_to do |format|
      if update_resource @user, user_params, stale_location: profile_path
        format.html { redirect_to root_url, notice: t('flash.profiles.update.notice') }
      else
        format.html { render :edit, alert: t('flash.profiles.update.alert') }
      end
    end
  end

  private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit :name, :lastname, :email, :password, :password_confirmation, :lock_version
    end
end
