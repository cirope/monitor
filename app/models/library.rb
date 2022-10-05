# frozen_string_literal: true

class Library < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Libraries::Print
  include Libraries::Relations
  include Libraries::Validation

  strip_fields :name

  def to_s
    name
  end
end
