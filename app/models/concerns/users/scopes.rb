module Users::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order :lastname, :name, :id }
  end

  module ClassMethods
    def by_role role
      where role: role
    end
  end
end
