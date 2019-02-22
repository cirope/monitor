module Memberships::Validation
  extend ActiveSupport::Concern

  included do
    validates :email, :account, presence: true
    validates :email, uniqueness: { case_sensitive: false, scope: :account }
  end
end
