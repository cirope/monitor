module Users::Permissions
  extend ActiveSupport::Concern

  def can_use_mine_filter?
    manager? || author? || supervisor?
  end

  def can_read_users?
    manager? || author? || supervisor?
  end

  def can_edit_issues?
    owner? || manager? || author? || supervisor?
  end
end
