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
                          default:  default,
                          restore:  user.restore?
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
      role            = user.role
      permissions     = role.permissions.to_a
      current_account = Current.account
      Current.account = self

      switch do
        new_role = Role.find_by(type: role.type) ||
                   create_role(role, permissions)

        User.create! user.attributes.except('id',
                                            'created_at',
                                            'updated_at',
                                            'lock_version'
                                           ).merge(role: new_role)
      end
    ensure
      Current.account = current_account
    end

    def create_role role, permissions
      new_role = Role.create! role.attributes.except 'id',
                                                     'created_at',
                                                     'updated_at',
                                                     'lock_version'

      permissions.each do |permission|
        new_role.permissions.create! permission.attributes.except 'id',
                                                                  'created_at',
                                                                  'updated_at'
      end

      new_role
    end
end
