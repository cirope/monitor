module Permissions::Validation
  extend ActiveSupport::Concern

  included do
    SECTIONS = {
      'Issue'         => { is_config: false },
      'Script'        => { is_config: false },
      'Schedule'      => { is_config: false },
      'Rule'          => { is_config: false },
      'Execution'     => { is_config: false },
      'Permalink'     => { is_config: false },
      'Run'           => { is_config: false },
      'Role'          => { is_config: true },
      'User'          => { is_config: true },
      'Record'        => { is_config: true },
      'Tag'           => { is_config: true },
      'Descriptor'    => { is_config: true },
      'Account'       => { is_config: true },
      'Server'        => { is_config: true },
      'Database'      => { is_config: true },
      'Ldap'          => { is_config: true },
      'Saml'          => { is_config: true },
      'Drive'         => { is_config: true },
      'PdfTemplate'   => { is_config: true },
      'Console'       => { is_config: true },
      'SystemMonitor' => { is_config: true },
    }

    validates :section, presence: true, inclusion: { in: Permission::SECTIONS.keys }
    validates :read, :edit, :remove, inclusion: { in: [true, false] }
  end
end
