# frozen_string_literal: true

class Descriptor < ApplicationRecord
  include Auditable
  include Descriptors::Validation

  def to_s
    name
  end
end
