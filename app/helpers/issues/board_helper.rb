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
end
