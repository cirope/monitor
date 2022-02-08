# frozen_string_literal: true

module Users::Views
  extend ActiveSupport::Concern

  included do
    has_many :views, dependent: :destroy
  end
end
