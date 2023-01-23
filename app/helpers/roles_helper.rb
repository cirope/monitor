module RolesHelper
  def role_permissions
    @role.permissions.new if @role.permissions.empty?

    @role.permissions
  end

  def permission_sections
    Permission::SECTIONS.keys.map do |section|
      [section.constantize.model_name.human(count: 0), section]
    end
  end

  def role_types
    Role::TYPES.map { |type| [t_role_type(type), type] }
  end

  def t_role_type type
    t "roles.types.#{type}"
  end
end
