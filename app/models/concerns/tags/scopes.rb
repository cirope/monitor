module Tags::Scopes
  extend ActiveSupport::Concern

  included do
    scope :for_users, -> { where kind: 'user' }
  end

  module ClassMethods
    def export export
      where "#{table_name}.options @> ?", { export: export }.to_json
    end

    def by_issues issues
      if issues.kind_of? ActiveRecord::Relation
        joins(:issues).merge(issues).distinct
      else
        joins(:issues).where(issues: { id: issues.map(&:id) }).distinct
      end
    end
  end
end
