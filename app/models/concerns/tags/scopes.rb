# frozen_string_literal: true

module Tags::Scopes
  extend ActiveSupport::Concern

  included do
    scope :for_users, -> { where kind: 'user' }
  end

  module ClassMethods
    def export export
      where "#{table_name}.options @> ?", { export: export }.to_json
    end

    def final final
      where "#{table_name}.options @> ?", { final: final }.to_json
    end

    def group_option group
      where "#{table_name}.options @> ?", { group: group }.to_json
    end

    def category category
      where "#{table_name}.options @> ?", { category: category }.to_json
    end

    def by_issues issues
      joins(:issues).merge(issues).distinct
    end
  end
end
