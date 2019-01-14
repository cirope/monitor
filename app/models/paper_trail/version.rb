class PaperTrail::Version < ::ActiveRecord::Base
  include PaperTrail::VersionConcern

  belongs_to :user,
    foreign_key: :whodunnit,
    class_name: User.name,
    optional: true
end
