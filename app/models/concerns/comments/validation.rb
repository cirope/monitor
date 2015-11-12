module Comments::Validation
  extend ActiveSupport::Concern

  included do
    validates :text, :user, presence: true
  end
end
