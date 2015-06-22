module SchedulesHelper
  def frequencies
    %w(hourly daily weekly monthly).map do |frequency|
      [t("schedules.frequencies.#{frequency}"), frequency]
    end
  end
end
