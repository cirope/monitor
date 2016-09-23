module Issues::Permissions
  extend ActiveSupport::Concern

  def can_be_edited_by? user
    user.supervisor? || (!user.guest? && users.include?(user))
  end
end
