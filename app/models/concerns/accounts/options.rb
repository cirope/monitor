module Accounts::Options
  extend ActiveSupport::Concern

  def group_issues_by_schedule
    options&.fetch 'group_issues_by_schedule', nil
  end
  alias_method :group_issues_by_schedule?, :group_issues_by_schedule

  def group_issues_by_schedule= value
    assign_option 'group_issues_by_schedule', value == true || value == '1'
  end

  private

    def assign_option name, value
      self.options ||= {}
      prev_value     = self.options[name]

      options_will_change! unless prev_value == value

      self.options[name] = value
    end
end
