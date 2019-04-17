# frozen_string_literal: true

module UsersHelper
  def roles
    User::ROLES.map { |k| [t("users.roles.#{k}"), k] }
  end

  def roles_label
    label = User.human_attribute_name 'role'
    link  = link_to '#users-role-help', data: { toggle: 'modal' } do
      icon 'fas', 'question-circle'
    end

    raw [label, link].join(' ')
  end

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
