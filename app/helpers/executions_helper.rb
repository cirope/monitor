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
            when 'killed'
              'label-warning'
            else
              'label-default'
            end

    content_tag :span, t("executions.status.#{status}"), class: "label #{klass}"
  end

  def link_to_force_kill_execution
    options = {
      class: 'btn btn-danger',
      title: t('.kill'),
      data:  {
        method:       :patch,
        remote:       true,
        params:       { force: true }.to_query,
        confirm:      t('messages.confirmation'),
        disable_with: t('.finishing')
      }
    }

    link_to [@script, @execution], options do
      raw [
        content_tag(:span, nil, class: 'glyphicon glyphicon-fire'),
        t('.kill')
      ].join ' '
    end
  end

  def link_to_kill_execution
    options = {
      class: 'btn btn-danger',
      title: t('.finish'),
      data:  {
        method:       :patch,
        remote:       true,
        confirm:      t('messages.confirmation'),
        disable_with: t('.finishing')
      }
    }

    link_to [@script, @execution], options do
      raw [
        content_tag(:span, nil, class: 'glyphicon glyphicon-screenshot'),
        t('.finish')
      ].join ' '
    end
  end
end
