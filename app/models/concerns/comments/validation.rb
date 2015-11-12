module Comments::Validation
  extend ActiveSupport::Concern

  included do
    before_validation :set_user, on: :create
    validates :text, :user, presence: true
  end

  private

    def set_user
      self.user_id = PaperTrail.whodunnit
    end
end
