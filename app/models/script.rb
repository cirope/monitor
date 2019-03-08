class Script < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include SearchableByName
  include Scripts::Copy
  include Scripts::Descriptions
  include Scripts::Destroy
  include Scripts::Export
  include Scripts::Import
  include Scripts::Injections
  include Scripts::Json
  include Scripts::Parameters
  include Scripts::Permissions
  include Scripts::Pdf
  include Scripts::Maintainers
  include Scripts::Requires
  include Scripts::Scopes
  include Scripts::Validation
  include Scripts::Versions
  include Filterable
  include Taggable

  mount_uploader :file, FileUploader

  strip_fields :name

  has_many :jobs, dependent: :destroy
  has_many :runs, through: :jobs
  has_many :issues, through: :runs
  has_many :executions, dependent: :destroy

  def to_s
    name
  end
end
