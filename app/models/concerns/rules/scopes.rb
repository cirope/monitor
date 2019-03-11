# frozen_string_literal: true

module Rules::Scopes
  extend ActiveSupport::Concern

  module ClassMethods
    def by_name name
      where "#{table_name}.name ILIKE ?", "%#{name}%"
    end
  end
end
