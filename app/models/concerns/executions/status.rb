module Executions::Status
  extend ActiveSupport::Concern

  included do
    enum status: {
      success: 'success',
      pending: 'pending',
      running: 'running',
      error:   'error'
    }
  end
end
