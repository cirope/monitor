# frozen_string_literal: true
# Does not work until https://github.com/paper-trail-gem/paper_trail/issues/1305 gets fixed

class PaperTrail::Version < ::ActiveRecord::Base
  include PaperTrail::VersionConcern

  belongs_to :user,
    foreign_key: :whodunnit,
    class_name: User.name,
    optional: true
end
