class ResourceStat < ApplicationRecord
  belongs_to :resourceable, polymorphic: true
end
