module Users::Scopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order :lastname, :name, :id }
    scope :visible, -> { where hidden: false }
    scope :hidden,  -> { where hidden: true }
  end

  module ClassMethods
    def by_name name
      where("#{table_name}.name ILIKE ?", "%#{name}%").
        or where("#{table_name}.lastname ILIKE ?", "%#{name}%")
    end

    def by_role role
      where role: role
    end

    def by_email email
      where "#{table_name}.email ILIKE ?", "%#{email}%"
    end

    def by_issues issues
      joins(:issues).merge(issues).distinct
    end
  end
end
