# frozen_string_literal: true
ROLES = {
  security: {
    name: 'Seguridad',
    description: 'Seguridad',
    permissions_attributes: [
      { section: 'Issue',         permit_read: true, permit_edit: true,  permit_destroy: false, admin: false },
      { section: 'User',          permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Record',        permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Tag',           permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'Account',       permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Server',        permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Database',      permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Ldap',          permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Saml',          permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Drive',         permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'SystemMonitor', permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'Permalink',     permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
    ]
  },
  supervisor: {
    name: 'Supervisor',
    description: 'Supervisor',
    permissions_attributes: [
      { section: 'Issue',         permit_read: true, permit_edit: true,  permit_destroy: true,  admin: true },
      { section: 'Script',        permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Schedule',      permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Rule',          permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Role',          permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'User',          permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Record',        permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Tag',           permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Descriptor',    permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Account',       permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Server',        permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'Database',      permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'Ldap',          permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'Saml',          permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'Drive',         permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'PdfTemplate',   permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Console',       permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'SystemMonitor', permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Execution',     permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Permalink',     permit_read: true, permit_edit: true,  permit_destroy: false, admin: false },
      { section: 'Run',           permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
    ]
  },
  author: {
    name: 'Autor',
    description: 'Autor',
    permissions_attributes: [
      { section: 'Issue',         permit_read: true, permit_edit: true,  permit_destroy: false, admin: false },
      { section: 'Script',        permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Schedule',      permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'User',          permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'Tag',           permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'PdfTemplate',   permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'SystemMonitor', permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'Execution',     permit_read: true, permit_edit: true,  permit_destroy: true,  admin: false },
      { section: 'Permalink',     permit_read: true, permit_edit: true,  permit_destroy: false, admin: false },
      { section: 'Run',           permit_read: true, permit_edit: true,  permit_destroy: false, admin: false },
    ]
  },
  manager: {
    name: 'Analista',
    description: 'Analista',
    permissions_attributes: [
      { section: 'Issue',     permit_read: true, permit_edit: true, permit_destroy: false, admin: false },
      { section: 'User',      permit_read: true, permit_edit: true, permit_destroy: true , admin: false },
      { section: 'Tag',       permit_read: true, permit_edit: true, permit_destroy: true,  admin: false },
      { section: 'Permalink', permit_read: true, permit_edit: true, permit_destroy: false, admin: false },
    ]
  },
  owner: {
    name: 'Propietario',
    description: 'Propietario',
    permissions_attributes: [
      { section: 'Issue',     permit_read: true, permit_edit: true,  permit_destroy: false, admin: false },
      { section: 'Tag',       permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'Permalink', permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
    ]
  },
  guest: {
    name: 'Invitado',
    description: 'Invitado',
    permissions_attributes: [
      { section: 'Issue',     permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'Tag',       permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
      { section: 'Permalink', permit_read: true, permit_edit: false, permit_destroy: false, admin: false },
    ]
  },
}
