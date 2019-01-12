module Scripts::Versions
  extend ActiveSupport::Concern

  def versions_with_text_changes
    versions.where(
      "#{versions.table_name}.object_changes ->> 'text' IS NOT NULL"
    )
  end
end
