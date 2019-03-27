# frozen_string_literal: true

class Execution < ApplicationRecord
  include Auditable
  include Executions::Callbacks
  include Executions::Run
  include Executions::Status
  include Executions::Validation
  include Outputs::Parser

  belongs_to :script
  belongs_to :server
  belongs_to :user
end
