# frozen_string_literal: true

module RunsHelper
  def run_status status
    klass = case status
            when 'ok'
              'bg-success'
            when 'error'
              'bg-danger'
            when 'canceled'
              'bg-warning'
            when 'aborted', 'killed'
              'bg-warning'
            else
              'bg-secondary'
            end

    content_tag :span, t("runs.status.#{status}"), class: "badge #{klass}"
  end

  def run_output
    if params[:full_output]
      @run.stdout
    else
      truncate @run.stdout, length: 200
    end
  end

  def run_time run
    if run.started_at && run.ended_at
      distance_of_time_in_words run.started_at, run.ended_at, include_seconds: true
    end
  end

  def filter_run_status
    Run.statuses.keys.map do |k|
      [t("runs.status.#{k}"), k]
    end
  end

  def link_to_force_kill_run
    options = {
      class: 'btn btn-sm btn-danger',
      title: t('.kill'),
      data:  {
        method:       :patch,
        remote:       true,
        params:       { force: true }.to_query,
        confirm:      t('messages.confirmation'),
        disable_with: t('.finishing')
      }
    }

    link_to @run, options do
      raw [
        icon('fas', 'skull'),
        t('.kill')
      ].join ' '
    end
  end

  def link_to_kill_run
    options = {
      class: 'btn btn-sm btn-danger',
      title: t('.finish'),
      data:  {
        method:       :patch,
        remote:       true,
        confirm:      t('messages.confirmation'),
        disable_with: t('.finishing')
      }
    }

    link_to @run, options do
      raw [
        icon('fas', 'stop-circle'),
        t('.finish')
      ].join ' '
    end
  end
end
