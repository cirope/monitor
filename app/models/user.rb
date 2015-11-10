class User < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include Attributes::Downcase
  include Users::Authentication
  include Users::Overrides
  include Users::PasswordReset
  include Users::Roles
  include Users::Search
  include Users::Validation

  strip_fields :name, :lastname, :email
  downcase_fields :email

  scope :ordered, -> { order :lastname, :name, :id }
end
