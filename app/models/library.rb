# frozen_string_literal: true

class Library < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Libraries::GemLine
  include Libraries::Validation

  strip_fields :name

  belongs_to :script, inverse_of: :libraries

  def to_s
    name
  end
end
