class Membership < ApplicationRecord
  include Attributes::Strip
  include Attributes::Downcase
  include Filterable
  include Memberships::Default
  include Memberships::Destroy
  include Memberships::Scopes
  include Memberships::Validation
  include PublicAuditable

  strip_fields :email, :username
  downcase_fields :email, :username

  belongs_to :account
  belongs_to :user, foreign_key: :email, primary_key: :email, optional: true,
    inverse_of: :memberships
end
