module Requires::Scopes
  extend ActiveSupport::Concern

  module ClassMethods
    def by_uuid uuids
      joins(:script).references(:scripts).where.not scripts: { uuid: uuids }
    end
  end
end
