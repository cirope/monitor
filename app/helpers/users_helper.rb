module UsersHelper
  def roles
    User::ROLES.map { |k| [t("users.roles.#{k}"), k] }
  end
end
