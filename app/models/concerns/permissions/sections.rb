module Permissions::Sections
  extend ActiveSupport::Concern

  included do
    MENU = {
      main: [
        { item: 'Issue',    controllers: ['Board', 'Comment', 'Permalink', 'Tagging', 'Export', 'View'] },
        { item: 'Ticket',   controllers: ['Comment'] },
        { item: 'Script',   controllers: ['Execution', 'Measure', 'Version', 'Revert', 'Import', 'Export', 'Parameter', 'Variable'] },
        { item: 'Schedule', controllers: ['Run', 'Job'] },
        { item: 'Rule',     controllers: ['Import', 'Export', 'Version', 'Revert'] },
      ],
      config: [
        { item: 'Role'          },
        { item: 'User',     controllers: ['Import'] },
        { item: 'Record'        },
        { item: 'Tag'           },
        { item: 'Descriptor'    },
        { item: 'Account'       },
        { item: 'Server',   controllers: ['Default'] },
        { item: 'Database'      },
        { item: 'Ldap'          },
        { item: 'Saml'          },
        { item: 'Drive'         },
        { item: 'PdfTemplate'   },
        { item: 'Console'       },
        { item: 'SystemMonitor' },
      ],
    }
  end

  module ClassMethods
    def main
      menu :main
    end

    def sections
      main + config
    end

    def config
      menu :config
    end

    def menu section
      Permission::MENU[section].map { |hsh| hsh[:item] }.flatten
    end
  end
end
