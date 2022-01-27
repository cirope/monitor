# frozen_string_literal: true

module Scripts::Permissions
  extend ActiveSupport::Concern

  def can_be_edited_by? user
    user.supervisor? || users.include?(user) || allow_tag_edit?
  end

  private

    def allow_tag_edit?
      tags.select(&:export_edit?).present?
    end
end
