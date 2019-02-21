module Users::Memberships
  extend ActiveSupport::Concern

  included do
    before_create :create_membership
    before_save   :update_memberships, on: :update

    has_many :memberships, foreign_key: :email, primary_key: :email
    has_one :current_membership, -> { current }, class_name: 'Membership',
      foreign_key: :email, primary_key: :email, dependent: :destroy
  end

  private

    def create_membership
      Current.account.enroll self, default: memberships.empty?
    end

    def update_memberships
      create_membership          if hidden_changed? && hidden == false
      update_membership_email    if email_changed?
      update_membership_username if username_changed? && username_was.present?
    end

    def update_membership_email
      if Membership.where(email: email).exists?
        errors.add :email, :taken
      else
        Membership.where(email: email_was).find_each do |membership|
          membership.update! email: email
        end
      end
    end

    def update_membership_username
      if Membership.where(username: username).where.not(email: email).exists?
        errors.add :username, :taken
      else
        Membership.where(username: username_was).find_each do |membership|
          membership.update! username: username
        end
      end
    end
end
