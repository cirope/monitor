module Users::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, :lastname, :role, presence: true
    validates :name, :lastname, :email, :username, :role, length: { maximum: 255 }
    validates :role, inclusion: { in: User::ROLES }
    validates :username, uniqueness: { case_sensitive: false }
    validates :email,
      uniqueness: { case_sensitive: false },
      presence: true,
      format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  end
end
