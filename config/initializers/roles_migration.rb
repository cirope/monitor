# frozen_string_literal: true
ROLES = {
  security: {
    name: 'Seguridad',
    description: 'Seguridad',
    permissions_attributes: [
      { section: 'Issue',         read: true, edit: true,  remove: false },
      { section: 'User',          read: true, edit: true,  remove: true  },
      { section: 'Role',          read: true, edit: true,  remove: true  },
      { section: 'Record',        read: true, edit: true,  remove: true  },
      { section: 'Tag',           read: true, edit: false, remove: false },
      { section: 'Account',       read: true, edit: true,  remove: true  },
      { section: 'Server',        read: true, edit: true,  remove: true  },
      { section: 'Database',      read: true, edit: true,  remove: true  },
      { section: 'Ldap',          read: true, edit: true,  remove: true  },
      { section: 'Saml',          read: true, edit: true,  remove: true  },
      { section: 'Drive',         read: true, edit: true,  remove: true  },
      { section: 'SystemMonitor', read: true, edit: false, remove: false },
      { section: 'Membership',    read: true, edit: true,  remove: false },
    ]
  },
  supervisor: {
    name: 'Supervisor',
    description: 'Supervisor',
    permissions_attributes: [
      { section: 'Issue',         read: true, edit: true,  remove: true  },
      { section: 'Script',        read: true, edit: true,  remove: true  },
      { section: 'Schedule',      read: true, edit: true,  remove: true  },
      { section: 'Rule',          read: true, edit: true,  remove: true  },
      { section: 'Role',          read: true, edit: true,  remove: true  },
      { section: 'User',          read: true, edit: true,  remove: true  },
      { section: 'Record',        read: true, edit: true,  remove: true  },
      { section: 'Tag',           read: true, edit: true,  remove: true  },
      { section: 'Descriptor',    read: true, edit: true,  remove: true  },
      { section: 'Account',       read: true, edit: true,  remove: true  },
      { section: 'Server',        read: true, edit: false, remove: false },
      { section: 'Database',      read: true, edit: false, remove: false },
      { section: 'Ldap',          read: true, edit: false, remove: false },
      { section: 'Saml',          read: true, edit: false, remove: false },
      { section: 'Drive',         read: true, edit: false, remove: false },
      { section: 'PdfTemplate',   read: true, edit: true,  remove: true  },
      { section: 'Console',       read: true, edit: true,  remove: true  },
      { section: 'SystemMonitor', read: true, edit: true,  remove: true  },
      { section: 'Membership',    read: true, edit: true,  remove: false },
    ]
  },
  author: {
    name: 'Autor',
    description: 'Autor',
    permissions_attributes: [
      { section: 'Issue',         read: true, edit: true,  remove: false },
      { section: 'Script',        read: true, edit: true,  remove: true  },
      { section: 'Schedule',      read: true, edit: false, remove: false },
      { section: 'User',          read: true, edit: false, remove: false },
      { section: 'Tag',           read: true, edit: false, remove: false },
      { section: 'PdfTemplate',   read: true, edit: true,  remove: true  },
      { section: 'SystemMonitor', read: true, edit: false, remove: false },
      { section: 'Membership',    read: true, edit: true,  remove: false },
    ]
  },
  manager: {
    name: 'Analista',
    description: 'Analista',
    permissions_attributes: [
      { section: 'Issue',      read: true, edit: true, remove: false },
      { section: 'User',       read: true, edit: true, remove: true  },
      { section: 'Tag',        read: true, edit: true, remove: true  },
      { section: 'Membership', read: true, edit: true, remove: false },
    ]
  },
  owner: {
    name: 'Propietario',
    description: 'Propietario',
    permissions_attributes: [
      { section: 'Issue',      read: true, edit: true,  remove: false },
      { section: 'Tag',        read: true, edit: false, remove: false },
      { section: 'Membership', read: true, edit: true,  remove: false },
    ]
  },
  guest: {
    name: 'Invitado',
    description: 'Invitado',
    permissions_attributes: [
      { section: 'Issue',      read: true, edit: false, remove: false },
      { section: 'Tag',        read: true, edit: false, remove: false },
      { section: 'Membership', read: true, edit: true,  remove: false },
    ]
  },
}
