# frozen_string_literal: true

module VersionsHelper
  def version_change_for version, column
    change = version.object_changes[column]&.last || (version.reify&.try(column.to_sym) || '-')

    if version.event == 'create'
      change += " (#{t 'versions.index.event.create'})"
    end

    change
  end

  def version_change_date_for version
    version.created_at
  end

  def text_diff_for_version version, column
    previous, current = *version.object_changes[column]

    raw Diffy::Diff.new(previous, current, include_plus_and_minus_in_html: true)
  end

  def version_whodunnit version
    User.find_by id: version.whodunnit
  end
end
