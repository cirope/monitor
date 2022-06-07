module ControlOutputs::Status
  extend ActiveSupport::Concern

  included do
    enum status: {
      ok:    'ok',
      error: 'error'
    }
  end
end
