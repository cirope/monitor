module Tags::Scopes
  extend ActiveSupport::Concern

  module ClassMethods
    def export export
      where "#{table_name}.options @> ?", { export: export }.to_json
    end
  end
end
