class Trigger < ActiveRecord::Base
  include Auditable

  validates :callback, presence: true

  belongs_to :rule
end
