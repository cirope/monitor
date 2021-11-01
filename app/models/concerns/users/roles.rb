# frozen_string_literal: true

module Users::Roles
  extend ActiveSupport::Concern

  ROLES_BADGES = {
    'security' => 'badge-danger',
    'supervisor' => 'badge-success',
    'author' => 'badge-info',
    'manager' => 'badge-secondary',
    'owner' => 'badge-primary',
    'guest' => 'badge-light'
  }

  included do
    ROLES = %w(security supervisor author manager owner guest)

    ROLES.each do |role|
      define_method "#{role}?" do
        self.role == role
      end
    end
  end

  def role_badge
    ROLES_BADGES[role]
  end
end
