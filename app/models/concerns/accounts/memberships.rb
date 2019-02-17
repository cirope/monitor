module Accounts::Memberships
  extend ActiveSupport::Concern

  included do
    has_many :memberships, dependent: :destroy
  end

  def enroll user, default: false
    memberships.create! email: user.email, default: default
  end
end
