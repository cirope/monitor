# frozen_string_literal: true

class Parameter < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Parameters::Validation

  strip_fields :name

  belongs_to :script, inverse_of: :parameters
end
