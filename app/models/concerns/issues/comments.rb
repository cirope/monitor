module Issues::Comments
  extend ActiveSupport::Concern

  included do
    has_many :comments, dependent: :destroy
    accepts_nested_attributes_for :comments, reject_if: :all_blank
  end
end
