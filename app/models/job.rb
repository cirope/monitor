# frozen_string_literal: true

class Job < ApplicationRecord

  #This should go here, otherwise it doesn't work, feel free to try
  alias_method :original_destroy, :destroy

  include Auditable
  include Jobs::Cleanup
  include Jobs::Destroy
  include Jobs::Validation

  belongs_to :schedule, optional: true
  belongs_to :server
  belongs_to :script
  has_many :runs, dependent: :destroy, autosave: true

  def to_s
    "#{script} -> #{schedule}"
  end
end
