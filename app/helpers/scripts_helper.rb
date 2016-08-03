module ScriptsHelper
  def maintainers
    @script.maintainers.new if @script.maintainers.empty?

    @script.maintainers
  end

  def requires
    @script.requires.new if @script.requires.empty?

    @script.requires
  end

  def script_taggings
    @script.taggings.new if @script.taggings.empty?

    @script.taggings
  end

  def file_identifier
    @script.file.identifier || @script.file_identifier if @script.file?
  end

  def parameters
    @script.parameters.new if @script.parameters.empty?

    @script.parameters
  end

  def descriptions
    if @script.descriptions.empty?
      Descriptor.all.each { |d| @script.descriptions.new name: d.name }
    end

    @script.descriptions
  end

  def disable_edition?
    @script.imported_at.present?
  end

  def imported_tag script
    if script.imported_at.present?
      date  = l script.imported_at, format: :compact
      title = t 'scripts.imports.default_change', date: date

      content_tag :abbr, title: title do
        content_tag :span, nil, class: 'glyphicon glyphicon-asterisk'
      end
    end
  end

  def last_change_diff
    previous = @script.paper_trail.previous_version

    raw Diffy::Diff.new(previous&.text, @script.text, include_plus_and_minus_in_html: true)
  end
end
