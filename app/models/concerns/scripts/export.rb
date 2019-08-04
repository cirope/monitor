module Scripts::Export
  extend ActiveSupport::Concern

  def exportables
    requires.map &:script
  end
end
