module Permissions::Sections
  extend ActiveSupport::Concern

  included do
    MENU = {
      main: [
        { item: 'Issue',    controllers: ['Board', 'Permalink', 'Export'] },
        { item: 'Script',   controllers: ['Execution', 'Measure', 'Version', 'Import', 'Export'] },
        { item: 'Schedule', controllers: ['Run'] },
        { item: 'Rule',     controllers: ['Import', 'Export'] },
      ],
      config: [
        { item: 'Role'          },
        { item: 'User',     controllers: ['Import'] },
        { item: 'Record'        },
        { item: 'Tag'           },
        { item: 'Descriptor'    },
        { item: 'Account'       },
        { item: 'Server'        },
        { item: 'Database'      },
        { item: 'Ldap'          },
        { item: 'Saml'          },
        { item: 'Drive'         },
        { item: 'PdfTemplate'   },
        { item: 'Console'       },
        { item: 'SystemMonitor' },
      ],
      user: [
        { item: 'Membership' },
      ],
      system: [
        { item: 'Authentication' },
        { item: 'Home' },
        { item: 'Profile' },
        { item: 'Session' },
        { item: 'Series' },
      ]
    }
  end

  module ClassMethods
    def main
      menu :main
    end

    def sections
      menu(:main) + menu(:config) + menu(:user)
    end

    def config
      menu :config
    end

    def system
      menu :system
    end

    def menu section
      Permission::MENU[section].map { |hsh| hsh[:item] }.flatten
    end
  end
end
