class Trigger < ActiveRecord::Base
  include Auditable
  include Triggers::Run
  include Triggers::Validation

  belongs_to :rule
end
