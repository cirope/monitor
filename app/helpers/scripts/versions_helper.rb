module Scripts::VersionsHelper
  def version_user_for version
    originator = version.paper_trail_originator || version.whodunnit

    User.find originator if originator
  end

  def version_change_for version
    version.event == 'create' ? t('.event.create') : (version.reify&.change || '-')
  end

  def version_change_date_for version
    version.reify&.updated_at || version.created_at
  end

  def version_diff_to_previous
    previous = @version.previous

    if previous
      raw Diffy::Diff.new(previous.reify&.text, @version.reify&.text, include_plus_and_minus_in_html: true)
    else
      content_tag :div, t('.no_previous'), class: 'alert alert-info'
    end
  end
end
