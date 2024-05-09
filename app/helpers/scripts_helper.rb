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

  def script_file_identifier
    @script.attachment.filename.to_s if @script.attachment.attached?
  end

  def parameters
    @script.parameters.new if @script.parameters.empty?

    @script.parameters
  end

  def libraries
    @script.libraries.new if @script.libraries.empty?

    @script.libraries
  end

  def descriptions
    if @script.descriptions.empty?
      Descriptor.all.each { |d| @script.descriptions.new name: d.name, public: d.public }
    end

    @script.descriptions
  end

  def disable_edition?
    !@script.is_editable?
  end

  def lang_icon script
    icon = case script.language
           when 'python' then icon 'fab', 'python'
           when 'ruby'   then icon 'fas', 'gem'
           when 'sql'    then icon 'fas', 'database'
           when 'shell'  then icon 'fas', 'hashtag'
           end

    status = if script.has_errors?
               'text-danger'
             elsif script.has_warnings?
               'text-warning'
             elsif script.status
               'text-success'
             else
               'text-secondary'
             end

    content_tag :abbr, class: status, title: script.language.titleize do
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

  def link_to_show_parameter_versions parameter
    if parameter.versions.count > 1
      link_to icon('fas', 'history'), [@script, parameter],
        remote: true, title: t('scripts.show.history')
    end
  end

  def script_documents
    @script.documents_attachments.select &:persisted?
  end

  def script_documents_identifier
    if @script.documents.attached?
      docs = @script.documents.select &:new_record?

      raw docs.map(&:filename).join('<br />')
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
