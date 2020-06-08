# frozen_string_literal: true

module Auditable
  extend ActiveSupport::Concern

  included do
    has_paper_trail ignore: [:lock_version]
  end
end
