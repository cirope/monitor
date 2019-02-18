module PublicAuditable
  extend ActiveSupport::Concern

  included do
    has_paper_trail ignore: [:lock_version], versions: {
      class_name: 'PublicVersion'
    }
  end
end
