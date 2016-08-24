module SchedulesHelper
  def frequencies
    %w(minutes hours days weeks months).map do |frequency|
      [t("schedules.frequencies.#{frequency}"), frequency]
    end
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

  def link_to_run &block
    url     = run_schedule_path @schedule
    options = {
      class:  'btn btn-default',
      method: :post,
      data:   {
        confirm: t('messages.confirmation')
      }
    }

    link_to url, options do
      capture &block if block_given?
    end
  end

  def link_to_cleanup schedule
    options = {
      title: t('schedules.cleanup'),
      data:  {
        method:  :delete,
        confirm: t('messages.confirmation')
      }
    }

    link_to cleanup_schedule_path(schedule), options do
      content_tag :span, nil, class: 'glyphicon glyphicon-erase'
    end
  end
end
