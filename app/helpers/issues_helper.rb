module IssuesHelper
  def issue_index_path
    current_user.guest? ? issues_path : script_issues_path(@script || @issue.script)
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
    link_to issue_board_path(issue), title: t('.add_to_board'), data: { remote: true, method: :post } do
      content_tag :span, nil, class: 'glyphicon glyphicon-plus-sign'
    end
  end

  def link_to_remove_from_board issue, options = { remote: true }
    link_to issue_board_path(issue), title: t('.remove_from_board'), data: { remote: options[:remote], method: :delete } do
      content_tag :span, nil, class: 'glyphicon glyphicon-minus-sign'
    end
  end
end
