class Script < ActiveRecord::Base
  include Attributes::Strip
  include Scripts::Copy
  include Scripts::Searchable
  include Scripts::Validation

  mount_uploader :file, FileUploader

  strip_fields :name

  has_many :schedules, dependent: :destroy

  def to_s
    name
  end
end
