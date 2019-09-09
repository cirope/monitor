# frozen_string_literal: true

class Script < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Exportable
  include SearchableByName
  include Scripts::Copy
  include Scripts::Descriptions
  include Scripts::Destroy
  include Scripts::Export
  include Scripts::Import
  include Scripts::Injections
  include Scripts::JSON
  include Scripts::ModeRuby
  include Scripts::Parameters
  include Scripts::Pdf
  include Scripts::Permissions
  include Scripts::Maintainers
  include Scripts::Requires
  include Scripts::Scopes
  include Scripts::Validation
  include Scripts::Versions
  include Filterable
  include Taggable

  mount_uploader :file, FileUploader

  strip_fields :name

  enum language: {
    ruby: 'ruby'
  }

  has_many :jobs, dependent: :destroy
  has_many :runs, through: :jobs
  has_many :issues, through: :runs
  has_many :executions, dependent: :destroy
  has_many :execution_measures, through: :executions, class_name: 'Measure', source: :measures
  has_many :run_measures, through: :runs, class_name: 'Measure', source: :measures

  def to_s
    name
  end
end
