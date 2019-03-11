# frozen_string_literal: true

module PublicAuditable
  extend ActiveSupport::Concern

  included do
    has_paper_trail ignore: [:lock_version], versions: { class_name: 'Version' }
  end
end
