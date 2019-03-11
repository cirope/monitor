# frozen_string_literal: true

module Accounts::Default
  extend ActiveSupport::Concern

  def default?
    tenant_name == 'default'
  end
end
