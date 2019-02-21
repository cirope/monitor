module Memberships::Scopes
  extend ActiveSupport::Concern

  included do
    scope :default, -> { where default: true }
    scope :current, -> { where account_id: Current.account&.id }
  end

  module ClassMethods
    def all_by_username_or_email username
      where(email: username.to_s.strip.downcase).
        or where(username: username.to_s.strip.downcase)
    end
  end
end
