# frozen_string_literal: true

class Parameter < ApplicationRecord
  include Auditable
  include Parameters::Validation

  belongs_to :script
end
