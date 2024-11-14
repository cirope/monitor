module Descriptors::Validation
  extend ActiveSupport::Concern

  included do
    validates :name,
      presence:   true,
      length:     { maximum: 255 },
      uniqueness: { case_sensitive: false }
    validates :public,
      inclusion: { in: [true, false] }
  end
end
