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
      data:  {
        remote: true,
        method: :post,
        toggle: :dropdown
      }
    }

    link_to permalinks_path(permalink: { issue_ids: @issue_ids }), options do
      t '.create_permalink'
    end
  end

  def link_to_download_issue_data
    options = {
      data:  {
        method: :post,
        toggle: :dropdown
      }
    }

    link_to issues_exports_path(ids: @issue_ids), options do
      t '.download_issue_data'
    end
  end

  def link_to_download_pdf
    link_to issues_board_path(format: :pdf) do
      t '.download_pdf'
    end
  end

  def link_to_destroy_all_issues
    options = {
      data: {
        method:  :delete,
        toggle:  :dropdown,
        confirm: t('messages.confirmation')
      }
    }

    link_to t('.destroy_all'), issues_board_destroy_all_path, options
  end
end
