module Roles::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, :description, presence: true, length: { maximum: 255 }
    validates :name, uniqueness: { case_sensitive: false }
  end
end
