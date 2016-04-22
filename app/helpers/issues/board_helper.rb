module Issues::BoardHelper
  def board_session
    session[:board_issues] ||= []
  end

  def issue_validation_errors issue
    errors = session[:board_issue_errors]
    error  = errors && errors[issue.id]

    if error
      content_tag :abbr, class: 'text-warning', title: error.join(' | ') do
        content_tag :span, nil, class: 'glyphicon glyphicon-warning-sign'
      end
    end
  end

  def link_to_create_permalink
    options = {
      class: 'btn btn-default btn-sm',
      data:  {
        remote: true,
        method: :post,
        action: 'create-permalink'
      }
    }

    link_to permalinks_path(permalink: { issue_ids: @issue_ids }), options do
      t '.create_permalink'
    end
  end
end
