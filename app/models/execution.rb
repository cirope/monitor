class Execution < ApplicationRecord
  has_paper_trail

  include Executions::Callbacks
  include Executions::Run
  include Executions::Validation

  belongs_to :script
  belongs_to :server
  belongs_to :user

  enum status: [:success, :pending, :running, :error]
end
