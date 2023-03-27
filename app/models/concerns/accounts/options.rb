module Accounts::Options
  extend ActiveSupport::Concern

  attr_writer :token_interval, :token_frequency

  included do
    before_validation :assign_token_duration
  end

  def expire_token
    eval "#{token_interval}.#{token_frequency}.from_now"
  end

  def group_issues_by_schedule
    options&.fetch 'group_issues_by_schedule', nil
  end
  alias_method :group_issues_by_schedule?, :group_issues_by_schedule

  def group_issues_by_schedule= value
    assign_option 'group_issues_by_schedule', value == true || value == '1'
  end

  def token_duration
    options&.fetch 'token_duration', nil
  end

  def token_duration= value
    assign_option 'token_duration', value
  end

  def token_interval
    interval, frequency = token_duration&.first

    @token_interval || interval || 1
  end

  def token_frequency
    interval, frequency = token_duration&.first

    @token_frequency || frequency || 'months'
  end

  private

    def assign_option name, value
      self.options ||= {}
      prev_value     = self.options[name]

      options_will_change! unless prev_value == value

      self.options[name] = value
    end

    def assign_token_duration
      self.token_duration = { token_interval => token_frequency }
    end
end
