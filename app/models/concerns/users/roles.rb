module Users::Roles
  extend ActiveSupport::Concern

  included do
    ROLES = %w(security supervisor author guest)
  end

  def guest?
    role == 'guest'
  end
end
