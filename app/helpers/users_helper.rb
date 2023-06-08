# frozen_string_literal: true

module UsersHelper
  def user_taggings
    @user.taggings.new if @user.taggings.empty?

    @user.taggings
  end

  def user_actions_columns
    if current_user.author?
      1
    elsif ldap
      2
    else
      3
    end
  end
end
