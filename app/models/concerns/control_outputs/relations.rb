module ControlOutputs::Relations
  extend ActiveSupport::Concern

  included do
    belongs_to :control
  end
end
