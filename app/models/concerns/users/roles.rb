# frozen_string_literal: true

module Users::Roles
  extend ActiveSupport::Concern

  included do
    belongs_to :role

    ROLES = %w(security supervisor author manager owner guest)

    ROLES.each do |role|
      define_method "#{role}?" do
        self.old_role == role
      end
    end
  end
end
