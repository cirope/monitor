# frozen_string_literal: true

module UsersHelper
  def user_taggings
    @user.taggings.new if @user.taggings.empty?

    @user.taggings
  end
end
