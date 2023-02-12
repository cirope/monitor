module RolesHelper
  def role_permissions
    permissions = @role.permissions.to_a

    Permission.sections.each_with_object([]) do |section, arr|
      permission = permissions.detect { |p| p.section == section } ||
        @role.permissions.new(section: section)

      arr << permission
    end
  end

  def permission_sections
    Permission.sections.map do |section|
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
