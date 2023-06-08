module Roles::Types
  extend ActiveSupport::Concern

  included do
    TYPES = %w(security supervisor author manager owner guest)

    TYPES.each do |type|
      define_method "#{type}?" do
        self.type == type
      end
    end
  end
end
