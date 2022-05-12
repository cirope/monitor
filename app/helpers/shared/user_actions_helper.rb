# frozen_string_literal: true

module Shared::UserActionsHelper
  def role_badge role
    case role
    when 'security'
      'badge-danger'
    when 'supervisor'
      'badge-success'
    when 'author'
      'badge-info'
    when 'manager'
      'badge-secondary'
    when 'owner'
      'badge-primary'
    when 'guest'
      'badge-light'
    end
  end
end
