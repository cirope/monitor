module UsersHelper
  def roles
    User::ROLES.map { |k| [t("users.roles.#{k}"), k] }
  end

  def roles_label
    label = User.human_attribute_name 'role'
    link  = link_to '#users-role-help', data: { toggle: 'modal' } do
      content_tag :span, nil, class: 'glyphicon glyphicon-question-sign'
    end

    raw [label, link].join(' ')
  end
end
