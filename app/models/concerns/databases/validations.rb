# frozen_string_literal: true

module Databases::Validations
  extend ActiveSupport::Concern

  included do
    validates :name, uniqueness: { case_sensitive: false }
    validates :name, :driver, :description, presence: true,
      length: { maximum: 255 }
  end
end
