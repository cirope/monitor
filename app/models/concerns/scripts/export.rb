module Scripts::Export
  extend ActiveSupport::Concern

  def exportables
    requires.map &:script
  end

  def export_filename
    "#{uuid}.json"
  end

  def export_content
    to_json
  end
end
