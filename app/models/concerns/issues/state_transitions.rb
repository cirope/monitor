# frozen_string_literal: true

module Issues::StateTransitions
  extend ActiveSupport::Concern

  included do
    before_save :maybe_store_state_transition
  end

  private

    def maybe_store_state_transition
      state_transitions[status] = Time.now.to_fs :db unless status_was == status
    end
end
