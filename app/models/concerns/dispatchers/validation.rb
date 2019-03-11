# frozen_string_literal: true

module Dispatchers::Validation
  extend ActiveSupport::Concern

  included do
    validates :rule, presence: :true
  end
end
