module Rules::Versions
  extend ActiveSupport::Concern

  included do
    has_many :trigger_versions, through: :triggers, source: :versions
  end

  def revert_to version
    reified  = version.reify dup: true
    callback = version.object_changes['callback']&.last || reified.callback
    trigger  = triggers.take

    trigger.update callback: callback
  end

  def versions_with_text_changes
    trigger_versions.where(
      "(#{versions.table_name}.object_changes ->> 'callback') IS NOT NULL"
    )
  end

  def version_text_column
    'callback'
  end

  def can_be_edited_by? user
    true
  end
end
