module Roles::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order "#{table_name}.name ASC" }
  end
end
