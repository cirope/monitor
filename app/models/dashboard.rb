# frozen_string_literal: true

class Dashboard < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Dashboards::Validation

  strip_fields :name

  belongs_to :user
  has_many :panels, dependent: :destroy

  def to_s
    name
  end

  def to_param
    "#{id}-#{name}".parameterize
  end
end
