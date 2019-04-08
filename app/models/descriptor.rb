# frozen_string_literal: true

class Descriptor < ApplicationRecord
  include Auditable

  validates :name,
    presence:   true,
    length:     { maximum: 255 },
    uniqueness: { case_sensitive: false }

  def to_s
    name
  end
end
