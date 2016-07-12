class Server < ActiveRecord::Base
  include Auditable
  include Attributes::Strip
  include Filterable
  include SearchableByName
  include Servers::Command
  include Servers::Local
  include Servers::Scopes
  include Servers::Ssh
  include Servers::Validation

  mount_uploader :credential, FileUploader

  scope :ordered, -> { order :name }

  strip_fields :name

  has_many :jobs, dependent: :destroy

  def to_s
    name
  end
end
