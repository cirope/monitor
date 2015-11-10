module SchedulesHelper
  def frequencies
    %w(minutes hours days weeks months).map do |frequency|
      [t("schedules.frequencies.#{frequency}"), frequency]
    end
  end

  def schedule_taggings
    @schedule.taggings.new if @schedule.taggings.empty?

    @schedule.taggings
  end

  def jobs
    @schedule.jobs.new if @schedule.jobs.empty?

    @schedule.jobs
  end

  def dependencies
    @schedule.dependencies.new if @schedule.dependencies.empty?

    @schedule.dependencies
  end

  def dispatchers
    @schedule.dispatchers.new if @schedule.dispatchers.empty?

    @schedule.dispatchers
  end

  def link_to_runs schedule
    link_to schedule_runs_path(schedule), title: Run.model_name.human(count: 0) do
      content_tag :span, nil, class: 'glyphicon glyphicon-console'
    end
  end
end
