class Server < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Servers::Command
  include Servers::Ssh
  include Servers::Validation

  mount_uploader :credential, FileUploader

  scope :ordered, -> { order :name }

  strip_fields :name

  has_many :schedules, dependent: :destroy

  def to_s
    name
  end
end
