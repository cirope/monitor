# frozen_string_literal: true

module Runs::Triggers
  extend ActiveSupport::Concern

  def execute_triggers
    dispatchers.each do |dispatcher|
      if dispatcher.rule.enabled
        dispatcher.rule.triggers.each { |trigger| trigger.run_on self }
      end
    end
  end
end
