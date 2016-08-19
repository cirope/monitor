module Comments::Owner
  extend ActiveSupport::Concern

  included do
    belongs_to :user
  end

  def owned_by? user
    user_id == user.id
  end
end
