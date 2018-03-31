module Comments::Validation
  extend ActiveSupport::Concern

  included do
    attr_readonly :user_id, :issue_id

    before_validation :set_user, on: :create
    validates :text, :user, presence: true
    validates :text, pdf_encoding: true
    validate :user_belongs_to_issue?, on: :create
  end

  private

    def set_user
      if PaperTrail.request.whodunnit
        self.user_id = PaperTrail.request.whodunnit
      end
    end

    def user_belongs_to_issue?
      allowed = user.supervisor? || user.issues.exists?(issue_id)

      errors.add :issue, :invalid unless allowed
    end
end
