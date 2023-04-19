# frozen_string_literal: true

module Issues::Survey
  extend ActiveSupport::Concern

  included do
    has_one :survey, dependent: :destroy
  end
end
