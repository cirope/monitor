module Memberships::Destroy
  extend ActiveSupport::Concern

  included do
    after_destroy :mark_other_as_default, if: :default
  end

  private

    def mark_other_as_default
      others    = Membership.where email: email, default: false
      with_ldap = others.detect do |membership|
        membership.account.switch do
          with_ldap = membership if Ldap.take
        end

        with_ldap
      end

      (with_ldap || others.take)&.update! default: true
    end
end
