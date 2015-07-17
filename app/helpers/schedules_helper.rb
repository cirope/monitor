module SchedulesHelper
  def frequencies
    %w(minutes hourly daily weekly monthly).map do |frequency|
      [t("schedules.frequencies.#{frequency}"), frequency]
    end
  end

  def dependencies
    @schedule.dependencies.new if @schedule.dependencies.empty?

    @schedule.dependencies
  end

  def link_to_runs schedule
    link_to schedule_runs_path(schedule), title: Run.model_name.human(count: 0) do
      content_tag :span, nil, class: 'glyphicon glyphicon-console'
    end
  end
end
