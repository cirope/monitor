# frozen_string_literal: true

class User < ApplicationRecord
  include Auditable
  include Filterable
  include Taggable
  include Attributes::Strip
  include Attributes::Downcase
  include Users::Authentication
  include Users::Licenses
  include Users::Memberships
  include Users::Notifications
  include Users::Origin
  include Users::Overrides
  include Users::PasswordReset
  include Users::Permissions
  include Users::Restore
  include Users::Roles
  include Users::Scopes
  include Users::Search
  include Users::Validation
  include Users::Visibility
  include Users::Views

  strip_fields :name, :lastname, :email, :username
  downcase_fields :email, :username

  has_many :comments, dependent: :destroy
  has_many :logins, dependent: :destroy
  has_many :maintainers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :issues, through: :subscriptions
  has_many :tickets, through: :subscriptions
  has_many :fails, dependent: :destroy
end
