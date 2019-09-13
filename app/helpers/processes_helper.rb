# frozen_string_literal: true

module ProcessesHelper
  def link_to_kill_process process
    options = {
      class: 'text-danger',
      title: t('.kill'),
      data:  {
        method:  :delete,
        confirm: t('messages.confirmation')
      }
    }

    link_to process_path(process.pid), options do
      icon 'fas', 'stop-circle'
    end
  end
end
