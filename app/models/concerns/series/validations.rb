module Series::Validations
  extend ActiveSupport::Concern

  included do
    validates :name, :date, :identifier, :amount, :count, presence: true
    validates :date, timeliness: { type: :date },
      allow_nil: true, allow_blank: true
    validates :amount, numericality: true, allow_blank: true, allow_nil: true
    validates :count, numericality: { only_integer: true, greater_than: 0 },
      allow_blank: true, allow_nil: true
  end
end
