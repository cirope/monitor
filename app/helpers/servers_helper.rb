# frozen_string_literal: true

module ServersHelper
  def link_to_server_default server
    if server.default
      content_tag :span, class: 'text-success', title: t('servers.index.default') do
        icon 'fas', 'toggle-on'
      end
    else
      options = {
        title: t('servers.index.make_default'),
        class: 'text-muted',
        data:  { remote: true, method: :patch }
      }

      link_to default_server_path(server.id) ,options do
        icon 'fas', 'toggle-off'
      end
    end
  end
end
