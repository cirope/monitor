module Permissions::Sections
  extend ActiveSupport::Concern

  included do
    SECTIONS = {
      menu: [
        'Issue',
        'Script',
        'Schedule',
        'Rule',
        'Permalink',
      ],
      menu_config: [
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
        'Home',
        'Profile',
        'Session'
      ]
    }
  end

  module ClassMethods
    def sections
      Permission::SECTIONS.fetch_values(:menu, :menu_config).flatten
    end

    def config_actions
      Permission::SECTIONS[:menu_config]
    end

    def system
      Permission::SECTIONS[:system]
    end
  end
end
