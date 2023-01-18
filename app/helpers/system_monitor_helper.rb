# frozen_string_literal: true

module SystemMonitorHelper
  def link_to_kill_process process
    options = {
      class: 'text-danger',
      title: t('.kill'),
      data:  {
        method:  :delete,
        confirm: t('messages.confirmation')
      }
    }

    link_to system_monitor_path(process.pid), options do
      icon 'fas', 'stop-circle'
    end
  end
end
