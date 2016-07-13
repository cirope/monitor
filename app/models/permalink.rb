class Permalink < ApplicationRecord
  include Auditable

  validates :token, presence: true, uniqueness: true, length: { maximum: 255 }

  has_and_belongs_to_many :issues

  def to_param
    persisted? ? token : nil
  end
end
