class Server < ActiveRecord::Base
  include Attributes::Strip
  include Servers::Searchable
  include Servers::Validation

  mount_uploader :credential, FileUploader

  strip_fields :name

  has_many :schedules, dependent: :destroy

  def to_s
    name
  end
end
