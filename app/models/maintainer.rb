class Maintainer < ActiveRecord::Base
  include Auditable

  validates :user, presence: true

  belongs_to :user
  belongs_to :script

  def to_s
    "#{user} -> #{script}"
  end
end
