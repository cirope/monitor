# frozen_string_literal: true

class ProfilesController < ApplicationController
  respond_to :html, :json

  before_action :authorize, :set_user, :set_title

  def edit
    respond_with @user
  end

  def update
    update_resource @user, user_params, stale_location: profile_path

    respond_with @user, location: root_url
  end

  private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit :name, :lastname, :email, :username, :password, :password_confirmation, :lock_version
    end
end
