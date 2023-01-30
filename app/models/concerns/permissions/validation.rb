module Permissions::Validation
  extend ActiveSupport::Concern

  included do
    validates :section, presence: true, inclusion: { in: Permission.sections }
    validates :read, :edit, :remove, inclusion: { in: [true, false] }
  end
end
