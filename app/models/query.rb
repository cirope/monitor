# frozen_string_literal: true

class Query < ApplicationRecord
  include Auditable
  include Queries::Defaults
  include Queries::Relations
  include Queries::Scopes
  include Queries::Validation

  def to_s
    title
  end
end

