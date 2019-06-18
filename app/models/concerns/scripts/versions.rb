# frozen_string_literal: true

module Scripts::Versions
  extend ActiveSupport::Concern

  def revert_to version
    reified = version.reify dup: true

    update(
      text:   version.object_changes['text']&.last || reified.text,
      change: I18n.t('scripts.reverts.reverted_from', title: reified.change)
    )
  end

  def versions_with_text_changes
    versions.where(
      "(#{versions.table_name}.object_changes ->> 'text') IS NOT NULL"
    )
  end
end
