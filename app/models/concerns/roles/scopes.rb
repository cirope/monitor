module Roles::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order "#{table_name}.name ASC" }
    scope :with_identifer, -> { where.not identifier: nil }
  end

  def permissions_for section
    permissions.ordered.where section: Permission.send(section)
  end
end
