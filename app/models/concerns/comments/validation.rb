# frozen_string_literal: true

module Comments::Validation
  extend ActiveSupport::Concern

  included do
    attr_readonly :user_id, :issue_id

    before_validation :set_user, on: :create

    validates :text, :user, presence: true
    validates :text, pdf_encoding: true
    validate :validate_user, on: :create
  end

  private

    def set_user
      self.user_id = Current.user.id if Current.user
    end

    def validate_user
      unless issue.ticket?
        allowed = user.supervisor? ||
                  user.manager?    ||
                  user.issues.exists?(issue_id)

        errors.add :issue, :invalid unless allowed
      end
    end
end
