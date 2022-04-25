# frozen_string_literal: true

module Users::Dashboards
  extend ActiveSupport::Concern

  included do
    has_many :dashboards, dependent: :destroy
    has_many :panels, through: :dashboards
  end
end
