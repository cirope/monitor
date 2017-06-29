module Issues::Comments
  extend ActiveSupport::Concern

  included do
    has_many :comments, dependent: :destroy
    has_one :last_comment, -> { order created_at: :desc }, class_name: 'Comment'
    accepts_nested_attributes_for :comments, reject_if: :all_blank
  end
end
