# frozen_string_literal: true

module Requires::Validation
  extend ActiveSupport::Concern

  included do
    validates :script, presence: true
    validate :script_is_not_included_on_caller
  end

  private

    def script_is_not_included_on_caller
      included_ids = [caller_id] + require_ids + Script.cores.ids

      errors.add :script, :taken if included_ids.include? script_id
    end

    def require_ids
      ids = Array(self.caller&.requires).map do |r|
        [r.script_id] + r.script.requires.pluck('script_id')
      end

      ids.flatten
    end
end
