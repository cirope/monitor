module Scripts::Permissions
  extend ActiveSupport::Concern

  def can_be_edited_by? user
    user.supervisor? || users.include?(user)
  end
end
