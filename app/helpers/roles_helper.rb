module RolesHelper
  def main_permissions
    permissions_for Permission.main
  end

  def config_permissions
    permissions_for Permission.config
  end

  def user_permissions
    permissions_for Permission.user
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

  def show_section section
    section.constantize.model_name.human count: 0
  end

  private

    def permissions_for section
      permissions = @role.permissions.to_a

      section.each_with_object([]) do |section, arr|
        permission = permissions.detect { |p| p.section == section } ||
          @role.permissions.new(section: section)

        arr << permission
      end
    end
end
