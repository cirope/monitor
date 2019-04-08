# frozen_string_literal: true

module Runs::Triggers
  extend ActiveSupport::Concern

  def execute_triggers
    if ok?
      dispatchers.each do |dispatcher|
        if dispatcher.rule.enabled
          dispatcher.rule.triggers.each do |trigger|
            trigger.run_on self
          end
        end
      end
    end
  end
end
