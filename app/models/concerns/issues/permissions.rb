# frozen_string_literal: true

module Issues::Permissions
  extend ActiveSupport::Concern

  def can_be_edited_by? user
    ticket? || user.supervisor? || user.manager? || (
      !(user.guest? || user.owner?) && users.include?(user)
    )
  end

  def can_be_light_edited_by? user
    (user.supervisor? || user.manager? || users.include?(user)) && !closed?
  end
end
