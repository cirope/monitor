# frozen_string_literal: true

module Executions::Validation
  extend ActiveSupport::Concern

  included do
    validates :script, :server, :user, presence: true
    validates :pid, numericality: { only_integer: true }, allow_blank: true
  end
end
