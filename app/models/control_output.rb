class ControlOutput < ApplicationRecord
  include ControlOutputs::Relations
  include ControlOutputs::Status
  include ControlOutputs::Validation
end
