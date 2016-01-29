module Tags::Validation
  extend ActiveSupport::Concern

  included do
    validates :name, :kind, presence: true, length: { maximum: 255 }
    validates :name, uniqueness: { case_sensitive: false }
    validates :kind, inclusion: { in: %w(script issue user) }
  end
end
