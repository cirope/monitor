# frozen_string_literal: true

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

  def lang_icon lang
    icon = case lang
           when 'ruby' then icon 'fas', 'gem'
           when 'sql'  then icon 'fas', 'database'
           end

    content_tag :abbr, title: lang.titleize do
      icon
    end
  end

  def imported_tag script
    if script.imported_at.present?
      date  = l script.imported_at, format: :compact
      title = t 'scripts.imports.default_change', date: date

      content_tag :abbr, title: title, class: 'text-info initialism mr-2' do
        icon 'fas', 'asterisk'
      end
    end
  end

  def last_change_diff
    previous = @script.paper_trail.previous_version
    options  = { include_plus_and_minus_in_html: true }

    Diffy::Diff.new(previous&.text, @script.text, options).to_s(:html).html_safe
  end

  def link_to_execute &block
    if @server
      link_to_create_execution &block
    else
      disabled_link_to_execute &block
    end
  end

  private

    def link_to_create_execution &block
      url     = script_executions_path @script
      options = {
        class: 'btn btn-sm btn-secondary',
        title: t('.execute_now'),
        data:  {
          method:  :post,
          confirm: t('messages.confirmation')
        }
      }

      link_to url, options do
        capture &block if block_given?
      end
    end

    def disabled_link_to_execute &block
      options = {
        title:    t('.no_server'),
        class:    'btn btn-sm btn-secondary',
        disabled: true
      }

      content_tag :button, options do
        capture &block if block_given?
      end
    end
end
