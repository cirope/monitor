module Roles::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, :description, presence: true, length: { maximum: 255 }
    validates :name, uniqueness: { case_sensitive: false }
    validates :type, presence: true, inclusion: { in: Role::TYPES }
    validates :identifier, uniqueness: { case_sensitive: false }, allow_nil: true
  end
end
