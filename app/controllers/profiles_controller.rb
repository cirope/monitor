# frozen_string_literal: true

class ProfilesController < ApplicationController
  include Authorization

  before_action :set_user, :set_title

  def edit
  end

  def update
    if @user.update user_params
      redirect_to root_url
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit :name, :lastname, :email, :username, :password, :password_confirmation, :lock_version
    end
end
