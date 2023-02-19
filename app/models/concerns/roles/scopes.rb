module Roles::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order "#{table_name}.name ASC" }
  end

  def permissions_for section
    permissions.where section: Permission.send(section)
  end
end
