# frozen_string_literal: true

module Outputs::Scopes
  extend ActiveSupport::Concern

  included do
    scope :with_text, -> { where.not text: '' }
  end
end
