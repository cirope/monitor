module Issues::Counters
  extend ActiveSupport::Concern

  included do
    after_create  :increment_script_counters
    after_update  :update_script_counters
    after_destroy :decrement_script_counters
  end

  private

    def increment_script_counters
      Script.increment_counter :active_issues_count, script.id unless closed?
    end

    def update_script_counters
      Script.decrement_counter :active_issues_count, script.id if status_changed? && closed?
    end

    def decrement_script_counters
      Script.decrement_counter :active_issues_count, script.id unless closed?
    end
end
