module Controls::Validation
  extend ActiveSupport::Concern

  included do
    validates :callback, presence: true, syntax: true, pdf_encoding: true
  end
end
