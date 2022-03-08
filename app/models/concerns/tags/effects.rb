# frozen_string_literal: true

module Tags::Effects
  extend ActiveSupport::Concern

  included do
    has_many :effects, dependent: :destroy, inverse_of: :tag

    accepts_nested_attributes_for :effects, allow_destroy: true, reject_if: :all_blank
  end

  def use_effects?
    kind == 'issue'
  end
end
