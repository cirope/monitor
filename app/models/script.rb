class Script < ActiveRecord::Base
  include Attributes::Strip
  include Scripts::Validation

  mount_uploader :file, FileUploader

  strip_fields :name

  def to_s
    name
  end
end
