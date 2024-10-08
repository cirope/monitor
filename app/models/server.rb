# frozen_string_literal: true

class Server < ApplicationRecord
  include Auditable
  include Attributes::Strip
  include Filterable
  include SearchableByName
  include Servers::Command
  include Servers::Default
  include Servers::Local
  include Servers::Scopes
  include Servers::Ssh
  include Servers::Validation

  has_one_attached :key

  scope :ordered, -> { order :name }

  strip_fields :name

  has_many :jobs, dependent: :restrict_with_error
  has_many :runs, dependent: :destroy

  def to_s
    name
  end
end
