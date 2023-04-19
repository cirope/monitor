# frozen_string_literal: true

class Control < ApplicationRecord
  include Auditable
  include Controls::Control
  include Controls::Relations
  include Controls::Validation
end
