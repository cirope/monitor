module IssuesHelper
  def issue_index_path
    if current_user.guest?
      issues_path
    elsif @permalink
      permalink_path @permalink
    elsif @script || @issue
      script_issues_path(@script || @issue.script)
    else
      issues_path
    end
  end

  def issue_actions_cols
    if current_user.guest? || current_user.security?
      2
    elsif current_user.author?
      3
    elsif params[:ids]
      1
    else
      4
    end
  end

  def issue_status status
    klass = case status
            when 'pending'
              'label-default'
            when 'taken'
              'label-warning'
            else
              'label-success'
            end

    content_tag :span, t("issues.status.#{status}"), class: "label #{klass}"
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

  def link_to_add_to_board issue
    options = {
      title: t('.add_to_board'),
      data:  {
        remote: true,
        method: :post
      }
    }

    link_to issues_board_path(filter: { id: issue }), options do
      content_tag :span, nil, class: 'glyphicon glyphicon-plus-sign'
    end
  end

  def link_to_remove_from_board issue, options = { remote: true }
    options = {
      title: t('.remove_from_board'),
      data:  {
        remote: options[:remote],
        method: :delete
      }
    }

    link_to issues_board_path(filter: { id: issue }), options do
      content_tag :span, nil, class: 'glyphicon glyphicon-minus-sign'
    end
  end

  def link_to_add_all_to_board
    options = {
      class: 'btn btn-xs btn-default',
      title: t('.add_all'),
      data:  { method: :post }
    }

    link_to issues_board_path_with_params, options do
      content_tag :span, nil, class: 'glyphicon glyphicon-ok-sign'
    end
  end

  def link_to_remove_all_from_board
    options = {
      class: 'btn btn-xs btn-default',
      title: t('.remove_all'),
      data:  { method: :delete }
    }

    link_to issues_board_path_with_params, options do
      content_tag :span, nil, class: 'glyphicon glyphicon-remove-sign'
    end
  end

  def limited_issue_form_edition?
    !@issue.can_be_edited_by? current_user
  end

  def link_to_export_data
    options = {
      title: t('.download_data'),
      data:  { method: :post }
    }

    link_to issues_exports_path(ids: [@issue.id]), options do
      content_tag :span, nil, class: 'glyphicon glyphicon-download'
    end
  end

  private

    def issues_board_path_with_params
      issues_board_path filter: filter_params.to_h, script_id: @script.id
    end
end
