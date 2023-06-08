# frozen_string_literal: true

module Tags::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, :kind, :style, presence: true, length: { maximum: 255 }
    validates :name, uniqueness: { case_sensitive: false }
    validates :kind, inclusion: { in: %w(script issue user ticket) }
    validates :style, inclusion: {
      in: %w(primary secondary success info warning danger)
    }
  end
end
