# frozen_string_literal: true

class Comment < ApplicationRecord
  include Auditable
  include Comments::Notify
  include Comments::Owner
  include Comments::Validation

  mount_uploader :file, FileUploader
  has_one_attached :attachment

  belongs_to :issue
  has_many :users, through: :issue

  def to_s
    text
  end
end
