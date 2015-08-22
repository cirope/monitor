module Taggings::Validation
  extend ActiveSupport::Concern

  included do
    validates :tag, presence: :true
  end
end
