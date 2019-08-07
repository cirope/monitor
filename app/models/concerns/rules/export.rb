module Rules::Export
  extend ActiveSupport::Concern

  def export_filename
    "#{uuid}.json"
  end

  def export_content
    to_json
  end
end
