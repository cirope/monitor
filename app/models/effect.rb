# frozen_string_literal: true

class Effect < ApplicationRecord
  include Auditable
  include Effects::Validation

  belongs_to :tag, inverse_of: :effects
  belongs_to :implied, class_name: 'Tag'
end
