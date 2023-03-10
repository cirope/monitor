module DisableSti
  extend ActiveSupport::Concern

  included do
    self.inheritance_column = :_type_disabled
  end
end
