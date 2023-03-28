# frozen_string_literal: true

class Description < ApplicationRecord
  include Auditable
  include Descriptions::Scopes
  include Descriptions::Validation

  belongs_to :script
end
