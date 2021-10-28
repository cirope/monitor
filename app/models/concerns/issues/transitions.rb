# frozen_string_literal: true

module Issues::Transitions
  extend ActiveSupport::Concern

  included do
    before_save :add_transition
  end

  private

    def add_transition
      transitions[Time.now.to_s :db] = status if status_was != status
    end
end
