class Job < ApplicationRecord
  include Auditable
  include Jobs::Validation

  belongs_to :schedule
  belongs_to :server
  belongs_to :script
  has_many :runs, dependent: :destroy, autosave: true

  def to_s
    "#{script} -> #{schedule}"
  end
end
