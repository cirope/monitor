module ExecutionsHelper
  def execution_status(status)
    klass = case status.to_s
            when 'success'
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
end
