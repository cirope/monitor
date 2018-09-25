module Permalinks::Validation
  extend ActiveSupport::Concern

  included do
    validates :token, presence: true, uniqueness: true, length: { maximum: 255 }
  end
end
