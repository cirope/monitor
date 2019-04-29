# frozen_string_literal: true

class Panel < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Panels::Validation

  strip_fields :title

  belongs_to :dashboard

  def to_s
    title
  end
end
