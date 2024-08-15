module Users::Permissions
  extend ActiveSupport::Concern

  def can_use_mine_filter?
    manager? || author? || supervisor?
  end
end
