class Server < ActiveRecord::Base
  include Attributes::Strip
  include Servers::Validation

  mount_uploader :credential, FileUploader

  strip_fields :name

  def to_s
    name
  end
end
