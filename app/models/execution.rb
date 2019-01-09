class Execution < ApplicationRecord
  include Auditable
  include Executions::Callbacks
  include Executions::Run
  include Executions::Validation

  belongs_to :script
  belongs_to :server
  belongs_to :user

  enum status: {
    success: 'success',
    pending: 'pending',
    running: 'running',
    error:   'error'
  }
end
