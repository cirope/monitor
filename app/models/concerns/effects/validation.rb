# frozen_string_literal: true

module Effects::Validation
  extend ActiveSupport::Concern

  included do
    validate :implied_not_equal_to_tag
  end

  private

    def implied_not_equal_to_tag
      errors.add :implied, :invalid if tag && tag.id == implied&.id
    end
end
