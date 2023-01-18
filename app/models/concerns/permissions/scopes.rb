module Permissions::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order "#{table_name}.section ASC" }
  end

  module ClassMethods
    def config_actions
      Permission::SECTIONS.select { |k,v| v[:is_config] == true }.keys
    end
  end
end
