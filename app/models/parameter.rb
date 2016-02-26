class Parameter < ActiveRecord::Base
  include Auditable
  include Parameters::Validation

  belongs_to :script
end
