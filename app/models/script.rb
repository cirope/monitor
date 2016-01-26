class Script < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Scripts::Copy
  include Scripts::Descriptions
  include Scripts::Destroy
  include Scripts::Requires
  include Scripts::Validation
  include Taggable

  mount_uploader :file, FileUploader

  scope :ordered, -> { order :name }

  strip_fields :name

  has_many :jobs, dependent: :destroy
  has_many :runs, through: :jobs
  has_many :issues, through: :runs

  def to_s
    name
  end
end
