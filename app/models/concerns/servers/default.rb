module Servers::Default
  extend ActiveSupport::Concern

  included do
    before_save :mark_others_as_not_default, if: :default
  end

  private

    def mark_others_as_not_default
      other_defaults = Server.default.where.not id: id

      other_defaults.each { |server| server.update! default: false }
    end
end
