module Runs::Triggers
  extend ActiveSupport::Concern

  included do
    has_many :dispatchers, through: :schedule
  end

  def execute_triggers
    dispatchers.each do |dispatcher|
      if dispatcher.rule.enable
        dispatcher.rule.triggers.each do |trigger|
          trigger.run_on self
        end
      end
    end
  end
end
