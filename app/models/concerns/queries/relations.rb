# frozen_string_literal: true

module Queries::Relations
  extend ActiveSupport::Concern

  included do
    belongs_to :panel
  end
end
