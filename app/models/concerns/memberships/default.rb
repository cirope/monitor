module Memberships::Default
  extend ActiveSupport::Concern

  included do
    before_update :mark_others_as_not_default, if: :default
  end

  private

    def mark_others_as_not_default
      unless default_was
        other_defaults = Membership.
          where(email: email, default: true).
          where.not id: id

        other_defaults.each { |membership| membership.update! default: false }
      end
    end
end
