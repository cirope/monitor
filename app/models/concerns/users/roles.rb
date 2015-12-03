module Users::Roles
  extend ActiveSupport::Concern

  included do
    ROLES = %w(security supervisor author guest)

    ROLES.each do |role|
      define_method "#{role}?" do
        self.role == role
      end
    end
  end
end
