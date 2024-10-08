# frozen_string_literal: true

class Script < ApplicationRecord
  include Attributes::Strip
  include Auditable
  include Exportable
  include Filterable
  include Scripts::Callbacks
  include Scripts::Cleanup
  include Scripts::Copy
  include Scripts::Cores
  include Scripts::Descriptions
  include Scripts::Destroy
  include Scripts::Export
  include Scripts::Import
  include Scripts::Injections
  include Scripts::PythonInjections
  include Scripts::Json
  include Scripts::Libraries
  include Scripts::Maintainers
  include Scripts::ModePython
  include Scripts::ModeRuby
  include Scripts::ModeShell
  include Scripts::ModeSql
  include Scripts::Parameters
  include Scripts::Pdf
  include Scripts::Permissions
  include Scripts::Requires
  include Scripts::Scopes
  include Scripts::Status
  include Scripts::Validation
  include Scripts::Variables
  include Scripts::Versions
  include SearchableByName
  include Taggable
  include Ticketable

  has_one_attached :attachment

  has_many_attached :documents
  accepts_nested_attributes_for :documents_attachments, allow_destroy: true

  strip_fields :name

  enum language: {
    'python' => 'python',
    'ruby'   => 'ruby',
    'sql'    => 'sql',
    'shell'  => 'shell'
  }

  has_many :jobs, dependent: :destroy
  has_many :runs, dependent: :destroy
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
