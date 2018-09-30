module RunsHelper
  def run_status status
    klass = case status
            when 'ok'
              'label-success'
            when 'error'
              'label-danger'
            when 'canceled'
              'label-warning'
            when 'aborted'
              'label-warning'
            else
              'label-default'
            end

    content_tag :span, t("runs.status.#{status}"), class: "label #{klass}"
  end

  def run_output
    if params[:full_output]
      @run.output
    else
      truncate @run.output, length: 200
    end
  end

  def run_time run
    if run.started_at && run.ended_at
      distance_of_time_in_words run.started_at, run.ended_at, include_seconds: true
    end
  end

  def filter_run_status
    %w(pending scheduled running ok error canceled aborted).map do |k|
      [t("runs.status.#{k}"), k]
    end
  end

  def runs_output_error_line_with_link(error, script)
    link = link_to(
      "L##{error[:line]}",
      script_path(script.id, line: error[:line]),
      target: '_blank'
    )

    [link, content_tag(:code, error[:error])].join(' | ').html_safe
  end
end
