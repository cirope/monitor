# frozen_string_literal: true

class Variable < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Variables::Validation

  strip_fields :name

  belongs_to :script, inverse_of: :variables
end
