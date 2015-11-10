class Rule < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Rules::Triggers

  validates :name, presence: true

  scope :ordered, -> { order :name }

  belongs_to :schedule
  has_many :dispatchers, dependent: :destroy

  strip_fields :name

  def to_s
    name
  end
end
