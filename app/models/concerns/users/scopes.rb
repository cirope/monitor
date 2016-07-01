module Users::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order :lastname, :name, :id }
  end

  module ClassMethods
    def by_name name
      conditions = [
        "#{table_name}.name ILIKE :name",
        "#{table_name}.lastname ILIKE :name"
      ].join(' OR ')

      where conditions, name: "%#{name}%"
    end

    def by_role role
      where role: role
    end

    def by_email email
      where "#{table_name}.email ILIKE ?", "%#{email}%"
    end
  end
end
