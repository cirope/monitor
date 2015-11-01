class Trigger < ActiveRecord::Base
  include Auditable

  validates :callback, :action, presence: true

  belongs_to :rule
end
