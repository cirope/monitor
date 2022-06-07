module Controls::Relations
  extend ActiveSupport::Concern

  included do
    belongs_to :survey
    has_one :issue, through: :survey
    has_one :run, through: :issue
    has_many :control_outputs, dependent: :destroy
  end
end
