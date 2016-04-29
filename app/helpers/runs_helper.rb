module RunsHelper
  def run_status status
    klass = case status
            when 'ok'
              'label-success'
            when 'error'
              'label-danger'
            when 'canceled'
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
end
