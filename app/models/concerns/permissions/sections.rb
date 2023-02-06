module Permissions::Sections
  extend ActiveSupport::Concern

  included do
    MENU = {
      main: [
        'Issue',
        'Script',
        'Schedule',
        'Rule',
        'Permalink',
      ],
      config: [
        'Role',
        'User',
        'Record',
        'Tag',
        'Descriptor',
        'Account',
        'Server',
        'Database',
        'Ldap',
        'Saml',
        'Drive',
        'PdfTemplate',
        'Console',
        'SystemMonitor'
      ],
      system: [
        'Authentication',
        'Home',
        'Profile',
        'Session'
      ]
    }
  end

  module ClassMethods
    def sections
      Permission::MENU.fetch_values(:main, :config).flatten
    end

    def config_actions
      Permission::MENU[:config]
    end

    def system
      Permission::MENU[:system]
    end
  end
end
