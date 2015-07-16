class Script < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Scripts::Copy
  include Scripts::Validation

  mount_uploader :file, FileUploader

  scope :ordered, -> { order :name }

  strip_fields :name

  has_many :schedules, dependent: :destroy

  def to_s
    name
  end
end
