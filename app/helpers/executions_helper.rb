# frozen_string_literal: true

module ExecutionsHelper
  def execution_status status
    klass = case status.to_s
            when 'success'
              'badge-success'
            when 'error'
              'badge-danger'
            when 'running'
              'badge-info'
            when 'killed'
              'badge-warning'
            else
              'badge-secondary'
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
        icon('far', 'stop-circle'),
        t('.finish')
      ].join ' '
    end
  end
end
