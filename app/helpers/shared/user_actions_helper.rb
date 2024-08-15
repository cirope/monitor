# frozen_string_literal: true

module Shared::UserActionsHelper
  def role_badge role
    case role&.type
    when 'security'
      'bg-danger'
    when 'supervisor'
      'bg-success'
    when 'author'
      'bg-info'
    when 'manager'
      'bg-secondary'
    when 'owner'
      'bg-primary'
    when 'guest'
      'bg-light text-dark'
    end
  end
end
