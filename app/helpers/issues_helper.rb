# frozen_string_literal: true

module IssuesHelper
  def issue_types
    Issue.ticket_types.map { |ot| [ot.constantize.model_name.human(count: 1), ot] }
  end

  def issue_index_path *args
    if @issue&.ticket?
      tickets_path *args
    elsif @context == :board
      issues_board_path *args
    elsif current_user.guest? || current_user.owner? || current_user.security?
      issues_path *args
    elsif @permalink
      permalink_path @permalink
    elsif @script || @issue
      script_issues_path(@script || @issue.script, *args)
    else
      issues_path *args
    end
  end

  def issue_actions_cols
    if current_user.guest? || current_user.owner? || current_user.security?
      1
    elsif current_user.owner?
      2
    elsif current_user.author? || current_user.manager?
      3
    elsif params[:ids]
      1
    else
      4
    end
  end

  def convert_issues issues
    issues.map { |issue| [issue, issue.converted_data.first] }
  end

  def grouped_issue_stats stats
    stats.inject({}) do |acc, ((key, status), count)|
      single_stats = acc[key] || {}

      single_stats[status] = count

      acc.merge key => single_stats
    end
  end

  def issue_stats_totals stats
    Issue.statuses.map do |status|
      total = stats.sum do |(_key, stat_status), count|
        stat_status == status ? count : 0
      end

      [status, total]
    end
  end

  def issue_status issue
    status = issue.status
    style  = issue_style issue

    content_tag :span, t("issues.status.#{status}"), class: "badge bg-#{style} p-1"
  end

  def status
    @issue.next_status.map { |k| [t("issues.status.#{k}"), k] }
  end

  def subscriptions
    @issue.subscriptions.new if @issue.subscriptions.empty?

    @issue.subscriptions
  end

  def issue_taggings
    @issue.taggings.new if @issue.taggings.empty?

    @issue.taggings
  end

  def comments
    [@issue.comments.detect(&:new_record?) || @issue.comments.new]
  end

  def is_in_board? issue
    board_session.include? issue.id
  end

  def issue_tagging_options issue
    kind = issue.ticket? ? 'ticket' : 'issue'

    {
      kind:       kind,
      collection: issue.options&.fetch('tag_group', nil)
    }
  end

  def link_to_add_to_board issue, url_params: {}
    url_params = url_params.merge filter: { id: issue }
    options    = {
      title: t('.add_to_board'),
      data:  {
        remote: true,
        method: :post
      }
    }

    link_to issues_board_path(url_params), options do
      icon 'fas', 'plus-circle'
    end
  end

  def link_to_remove_from_board issue, options: { remote: true }, url_params: {}
    url_params = url_params.merge filter: { id: issue }
    options    = {
      title: t('.remove_from_board'),
      data:  {
        remote: options[:remote],
        method: :delete
      }
    }

    link_to issues_board_path(url_params), options do
      icon 'fas', 'minus-circle'
    end
  end

  def link_to_add_all_to_board params = {}
    options = {
      class: 'btn btn-sm btn-secondary py-0',
      title: t('.add_all'),
      data:  { method: :post }
    }

    link_to issues_board_path_with_params(params), options do
      icon 'fas', 'check-circle'
    end
  end

  def link_to_remove_all_from_board params = {}
    options = {
      class: 'btn btn-sm btn-secondary py-0',
      title: t('.remove_all'),
      data:  { method: :delete }
    }

    link_to issues_board_path_with_params(params), options do
      icon 'fas', 'times-circle'
    end
  end

  def limited_issue_tag_form_edition?
    !@issue.can_be_light_edited_by? current_user
  end

  def limited_issue_form_edition?
    !@issue.can_be_edited_by? current_user
  end

  def can_edit_status?
    !limited_issue_form_edition? || current_user.owner?
  end

  def link_to_export_data
    options = {
      title: t('.download_data'),
      data:  { method: :post }
    }

    link_to issues_exports_path(ids: [@issue.id]), options do
      icon 'fas', 'arrow-alt-circle-down'
    end
  end

  def link_to_api_issues script_id
    options = {
      class: 'dropdown-item',
      data:  {
        remote: true,
        method: :post,
        toggle: :dropdown
      }
    }

    link_to script_api_issues_path(script_id: script_id), options do
      t 'issues.index_alt.api_issues'
    end
  end

  def link_to_download_issues_csv
    url_options = {
      filter: filter_query_hash.except(:status, :key),
      format: :csv
    }

    options = {
      class: 'dropdown-item'
    }

    link_to script_issues_path(@script, url_options), options do
      t 'issues.index_alt.download_csv'
    end
  end

  def filter_original_query_hash
    if params[:filter].present? && params[:filter][:original_filter].present?
      JSON.parse params[:filter][:original_filter]
    else
      filter_query_hash
    end
  end

  def issues_owner issue
    owner_label =  issue.owner_type.constantize.model_name.human count: 1
    owner_label += " (#{truncate issue.owner.to_s, length: 30})" if issue.owner

    owner_label
  end

  def link_to_issue_owner issue
    model = issue.owner_type.downcase

    if issue.owner
      owner_url = [issue, issue.owner]
      title     = 'show.title'
    else
      owner_url = [:new, issue, model.to_sym]
      title     = 'index.new'
    end

    link_to icon('fas', issue.owner_icon), owner_url, title: t(title, scope: model.pluralize)
  end

  def owner_issues
    Issue.availables(@ticket.owner_type).map { |issue| [issue.to_s, issue.id] }
  end

  def submit_issue
    action = @issue.new_record? ? 'create' : 'update'
    model  = @issue.ticket? ? Ticket : Issue

    t "helpers.submit.#{action}", model: model.model_name.human(count: 1)
  end

  private

    def issues_board_path_with_params custom_params
      default_params = { filter: filter_params.to_h, script_id: @script.id }

      issues_board_path default_params.merge(custom_params)
    end

    def issue_final_tag_style issue
      issue.tags.detect(&:final?)&.style
    end

    def issue_style issue
      case issue.status
      when 'pending'
        'secondary'
      when 'taken'
        'warning'
      when 'revision'
        'info'
      else
        issue_final_tag_style(issue) || 'success'
      end
    end
end
