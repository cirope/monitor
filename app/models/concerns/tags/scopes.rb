module Tags::Scopes
  extend ActiveSupport::Concern

  included do
    scope :for_users, -> { where kind: 'user' }
  end

  module ClassMethods
    def export export
      where "#{table_name}.options @> ?", { export: export }.to_json
    end
  end
end
