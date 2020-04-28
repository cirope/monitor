# frozen_string_literal: true

class Panel < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Panels::Queries
  include Panels::Scopes
  include Panels::Validation

  strip_fields :title

  def to_s
    title
  end
end
