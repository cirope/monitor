module Descriptions::Scopes
  extend ActiveSupport::Concern

  included do
    scope :publics, -> { where public: true }
  end
end
