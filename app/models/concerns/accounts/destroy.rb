# frozen_string_literal: true

module Accounts::Destroy
  extend ActiveSupport::Concern

  included do
    before_destroy :allow_destruction?
  end

  def allow_destruction?
    throw :abort
  end
end
