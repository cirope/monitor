# frozen_string_literal: true

class Trigger < ApplicationRecord
  include Auditable
  include Triggers::Run
  include Triggers::Validation

  belongs_to :rule
end
