# frozen_string_literal: true

module ExecutionsHelper
  def execution_status status
    klass = case status.to_s
            when 'success'
              'bg-success'
            when 'error'
              'bg-danger'
            when 'running'
              'bg-info'
            when 'killed'
              'bg-warning'
            else
              'bg-secondary'
            end

    content_tag :span, t("executions.status.#{status}"), class: "badge #{klass}"
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
        icon('fas', 'skull'),
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
        icon('fas', 'stop-circle'),
        t('.finish')
      ].join ' '
    end
  end

  def link_to_cleanup_executions script
    options = {
      title: t('executions.cleanup'),
      data:  {
        method:  :delete,
        confirm: t('messages.confirmation')
      }
    }

    link_to cleanup_script_executions_url(script), options do
      icon 'fas', 'eraser'
    end
  end
end
