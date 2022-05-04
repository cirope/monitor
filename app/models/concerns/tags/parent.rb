module Tags::Parent
  extend ActiveSupport::Concern

  included do
    belongs_to :parent, class_name: 'Tag', optional: true

    has_many :children, -> { order :name }, dependent: :nullify, class_name: 'Tag', foreign_key: 'parent_id'
  end

  def use_parent?
    kind == 'issue'
  end
end
