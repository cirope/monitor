# frozen_string_literal: true

module Scripts::Versions
  extend ActiveSupport::Concern

  def revert_to version
    reified = version.reify dup: true
    text    = version.object_changes['text']&.last   || reified.text
    change  = version.object_changes['change']&.last || reified.change

    update(
      text:   text,
      change: I18n.t('scripts.reverts.reverted_from', title: change)
    )
  end

  def versions_with_text_changes
    versions.where(
      "(#{versions.table_name}.object_changes ->> 'text') IS NOT NULL"
    )
  end

  def default_version
    '1.0.0'
  end

  def current_version
    MonitorApp::Application::VERSION
  end
end
