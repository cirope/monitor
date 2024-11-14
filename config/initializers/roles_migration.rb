# frozen_string_literal: true
# Used by seed, do not delete this file

I18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}')]
I18n.available_locales = [:es]
I18n.default_locale = :es

ROLES = {
  security: {
    permissions_attributes: [
      { section: 'Issue',         read: true,  edit: true,  remove: false },
      { section: 'Ticket',        read: true,  edit: true,  remove: false },
      { section: 'Script',        read: false, edit: false, remove: false },
      { section: 'Schedule',      read: false, edit: false, remove: false },
      { section: 'Rule',          read: false, edit: false, remove: false },
      { section: 'Role',          read: true,  edit: true,  remove: true  },
      { section: 'User',          read: true,  edit: true,  remove: true  },
      { section: 'Record',        read: true,  edit: true,  remove: true  },
      { section: 'Tag',           read: true,  edit: false, remove: false },
      { section: 'Descriptor',    read: false, edit: false, remove: false },
      { section: 'Account',       read: true,  edit: true,  remove: true  },
      { section: 'Server',        read: true,  edit: true,  remove: true  },
      { section: 'Database',      read: true,  edit: true,  remove: true  },
      { section: 'Ldap',          read: true,  edit: true,  remove: true  },
      { section: 'Saml',          read: true,  edit: true,  remove: true  },
      { section: 'Drive',         read: true,  edit: true,  remove: true  },
      { section: 'PdfTemplate',   read: false, edit: false, remove: false },
      { section: 'Console',       read: false, edit: false, remove: false },
      { section: 'SystemMonitor', read: true,  edit: false, remove: false },
    ]
  },
  supervisor: {
    permissions_attributes: [
      { section: 'Issue',         read: true, edit: true,  remove: true  },
      { section: 'Ticket',        read: true, edit: true,  remove: true  },
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
    ]
  },
  author: {
    permissions_attributes: [
      { section: 'Issue',         read: true,  edit: true,  remove: false },
      { section: 'Ticket',        read: true,  edit: true,  remove: false },
      { section: 'Script',        read: true,  edit: true,  remove: true  },
      { section: 'Schedule',      read: true,  edit: false, remove: false },
      { section: 'Rule',          read: false, edit: false, remove: false },
      { section: 'Role',          read: false, edit: false, remove: false },
      { section: 'User',          read: true,  edit: false, remove: false },
      { section: 'Record',        read: false, edit: false, remove: false },
      { section: 'Tag',           read: true,  edit: false, remove: false },
      { section: 'Descriptor',    read: false, edit: false, remove: false },
      { section: 'Account',       read: false, edit: false, remove: false },
      { section: 'Server',        read: false, edit: false, remove: false },
      { section: 'Database',      read: false, edit: false, remove: false },
      { section: 'Ldap',          read: false, edit: false, remove: false },
      { section: 'Saml',          read: false, edit: false, remove: false },
      { section: 'Drive',         read: false, edit: false, remove: false },
      { section: 'PdfTemplate',   read: true,  edit: true,  remove: true  },
      { section: 'Console',       read: false, edit: false, remove: false },
      { section: 'SystemMonitor', read: true,  edit: false, remove: false },
    ]
  },
  manager: {
    permissions_attributes: [
      { section: 'Issue',         read: true,  edit: true,  remove: false },
      { section: 'Ticket',        read: true,  edit: true,  remove: false },
      { section: 'Script',        read: false, edit: false, remove: false },
      { section: 'Schedule',      read: false, edit: false, remove: false },
      { section: 'Rule',          read: false, edit: false, remove: false },
      { section: 'Role',          read: false, edit: false, remove: false },
      { section: 'User',          read: true,  edit: true,  remove: true  },
      { section: 'Record',        read: false, edit: false, remove: false },
      { section: 'Tag',           read: true,  edit: true,  remove: true  },
      { section: 'Descriptor',    read: false, edit: false, remove: false },
      { section: 'Account',       read: false, edit: false, remove: false },
      { section: 'Server',        read: false, edit: false, remove: false },
      { section: 'Database',      read: false, edit: false, remove: false },
      { section: 'Ldap',          read: false, edit: false, remove: false },
      { section: 'Saml',          read: false, edit: false, remove: false },
      { section: 'Drive',         read: false, edit: false, remove: false },
      { section: 'PdfTemplate',   read: false, edit: false, remove: false },
      { section: 'Console',       read: false, edit: false, remove: false },
      { section: 'SystemMonitor', read: false, edit: false, remove: false },
    ]
  },
  owner: {
    permissions_attributes: [
      { section: 'Issue',         read: true,  edit: true,  remove: false },
      { section: 'Ticket',        read: true,  edit: true,  remove: false },
      { section: 'Script',        read: false, edit: false, remove: false },
      { section: 'Schedule',      read: false, edit: false, remove: false },
      { section: 'Rule',          read: false, edit: false, remove: false },
      { section: 'Role',          read: false, edit: false, remove: false },
      { section: 'User',          read: false, edit: false, remove: false },
      { section: 'Record',        read: false, edit: false, remove: false },
      { section: 'Tag',           read: true,  edit: false, remove: false },
      { section: 'Descriptor',    read: false, edit: false, remove: false },
      { section: 'Account',       read: false, edit: false, remove: false },
      { section: 'Server',        read: false, edit: false, remove: false },
      { section: 'Database',      read: false, edit: false, remove: false },
      { section: 'Ldap',          read: false, edit: false, remove: false },
      { section: 'Saml',          read: false, edit: false, remove: false },
      { section: 'Drive',         read: false, edit: false, remove: false },
      { section: 'PdfTemplate',   read: false, edit: false, remove: false },
      { section: 'Console',       read: false, edit: false, remove: false },
      { section: 'SystemMonitor', read: false, edit: false, remove: false },
    ]
  },
  guest: {
    permissions_attributes: [
      { section: 'Issue',         read: true,  edit: false, remove: false },
      { section: 'Ticket',        read: true,  edit: false, remove: false },
      { section: 'Script',        read: false, edit: false, remove: false },
      { section: 'Schedule',      read: false, edit: false, remove: false },
      { section: 'Rule',          read: false, edit: false, remove: false },
      { section: 'Role',          read: false, edit: false, remove: false },
      { section: 'User',          read: false, edit: false, remove: false },
      { section: 'Record',        read: false, edit: false, remove: false },
      { section: 'Tag',           read: true,  edit: false, remove: false },
      { section: 'Descriptor',    read: false, edit: false, remove: false },
      { section: 'Account',       read: false, edit: false, remove: false },
      { section: 'Server',        read: false, edit: false, remove: false },
      { section: 'Database',      read: false, edit: false, remove: false },
      { section: 'Ldap',          read: false, edit: false, remove: false },
      { section: 'Saml',          read: false, edit: false, remove: false },
      { section: 'Drive',         read: false, edit: false, remove: false },
      { section: 'PdfTemplate',   read: false, edit: false, remove: false },
      { section: 'Console',       read: false, edit: false, remove: false },
      { section: 'SystemMonitor', read: false, edit: false, remove: false },
    ]
  },
}

%w(security supervisor author manager owner guest).each do |type|
  role = I18n.t "roles.types.#{type}"

  ROLES[type.to_sym].merge! name: role, description: role
end
