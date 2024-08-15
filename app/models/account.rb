# frozen_string_literal: true

class Account < ApplicationRecord
  include Attributes::Strip
  include Attributes::Downcase
  include Accounts::Default
  include Accounts::Destroy
  include Accounts::Memberships
  include Accounts::OnEach
  include Accounts::Options
  include Accounts::Request
  include Accounts::Scope
  include Accounts::Tenant
  include Accounts::Validation
  include PublicAuditable
  include Filterable

  strip_fields :name, :tenant_name
  downcase_fields :tenant_name

  attr_readonly :tenant_name

  has_many :databases, dependent: :destroy
  has_many :drives,    dependent: :destroy

  def to_s
    name
  end

  def to_param
    tenant_name
  end
end
