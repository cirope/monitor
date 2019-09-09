# frozen_string_literal: true

module Users::Memberships
  extend ActiveSupport::Concern

  included do
    before_create :create_membership
    before_update :update_memberships

    has_many :memberships, foreign_key: :email, primary_key: :email,
      inverse_of: :user
    has_one :default_membership, -> { default }, class_name: 'Membership',
      foreign_key: :email, primary_key: :email
    has_one :current_membership, -> { current }, class_name: 'Membership',
      foreign_key: :email, primary_key: :email, dependent: :destroy
  end

  private

    def create_membership
      memberships.build username: username,
                        account:  Current.account,
                        default:  memberships.empty?
    end

    def update_memberships
      create_membership          if hidden_changed? && hidden == false
      update_membership_email    if email_changed?
      update_membership_username if username_changed? && username_was.present?
    end

    def update_membership_email
      Membership.where(email: email_was).find_each do |membership|
        membership.update! email: email
      end
    end

    def update_membership_username
      Membership.where(username: username_was).find_each do |membership|
        membership.update! username: username
      end
    end
end
