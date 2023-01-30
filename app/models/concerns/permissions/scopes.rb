module Permissions::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order "#{table_name}.section ASC" }
  end
end
