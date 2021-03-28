# frozen_string_literal: true

module Series::Validations
  extend ActiveSupport::Concern

  included do
    validates :name, :timestamp, :identifier, :amount, presence: true
    validates :timestamp, timeliness: { type: :datetime },
      allow_nil: true, allow_blank: true
    validates :amount, numericality: true, allow_blank: true, allow_nil: true
  end
end
