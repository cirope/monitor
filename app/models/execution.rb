# frozen_string_literal: true

class Execution < ApplicationRecord
  include Auditable
  include Killable
  include Executions::Callbacks
  include Executions::Cleanup
  include Executions::Run
  include Executions::Scopes
  include Executions::Status
  include Executions::Validation
  include Measurable
  include Outputs::Parser
  include Outputs::Status

  belongs_to :script
  belongs_to :server
  belongs_to :user
end
