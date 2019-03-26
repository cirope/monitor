# frozen_string_literal: true

module ExecutionsHelper
  def execution_status status
    klass = case status.to_s
            when 'success'
              'label-success'
            when 'error'
              'label-danger'
            when 'running'
              'label-info'
            else
              'label-default'
            end

    content_tag :span, t("executions.status.#{status}"), class: "label #{klass}"
  end
end
