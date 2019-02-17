class Membership < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Attributes::Downcase
  include Memberships::Validation

  strip_fields :email
  downcase_fields :email

  belongs_to :account
end
