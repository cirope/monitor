# frozen_string_literal: true

class Script < ApplicationRecord
  include Attributes::Strip
  include Auditable
  include Exportable
  include Filterable
  include Scripts::Copy
  include Scripts::Descriptions
  include Scripts::Destroy
  include Scripts::Export
  include Scripts::Import
  include Scripts::Injections
  include Scripts::Json
  include Scripts::Maintainers
  include Scripts::ModeContainer
  include Scripts::ModeRuby
  include Scripts::ModeSql
  include Scripts::Parameters
  include Scripts::Pdf
  include Scripts::Permissions
  include Scripts::Requires
  include Scripts::Scopes
  include Scripts::Validation
  include Scripts::Versions
  include SearchableByName
  include Taggable

  has_one_attached :attachment

  strip_fields :name

  enum language: {
    'ruby' => 'ruby',
    'sql'  => 'sql',
    'container' => 'container'
  }

  has_many :jobs, dependent: :destroy
  has_many :runs, through: :jobs
  has_many :issues, through: :runs
  has_many :executions, dependent: :destroy
  has_many :execution_measures, through: :executions, class_name: 'Measure', source: :measures
  has_many :run_measures, through: :runs, class_name: 'Measure', source: :measures
  belongs_to :database, optional: true

  attribute :imported_version, :string

  def to_s
    name
  end
end
