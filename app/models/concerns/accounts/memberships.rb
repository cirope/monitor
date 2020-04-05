# frozen_string_literal: true

module Accounts::Memberships
  extend ActiveSupport::Concern

  included do
    has_many :memberships, dependent: :destroy
  end

  def enroll user, default: false, copy_user: false
    if copy_user
      create_user user
    else
      memberships.create! email:    user.email,
                          username: user.username,
                          default:  default
    end
  end

  module ClassMethods
    def default_by_username_or_email username
      joins(:memberships).references(:memberships).merge(
        Membership.default
      ).merge(
        Membership.all_by_username_or_email username
      ).take
    end
  end

  private

    def create_user user
      current_account = Current.account
      Current.account = self

      switch do
        User.create! user.attributes.except 'id',
                                            'created_at',
                                            'updated_at',
                                            'lock_version'
      end
    ensure
      Current.account = current_account
    end
end
