# frozen_string_literal: true

module Issues::BoardHelper
  def board_session
    session[:board_issues] ||= []
  end

  def issue_validation_errors issue
    errors = session[:board_issue_errors]
    error  = errors && errors[issue.id]

    if error
      content_tag :abbr, class: 'text-warning', title: error.join(' | ') do
        icon 'fas', 'exclamation-triangle'
      end
    end
  end

  def issues_board_status
    Issue.statuses.map { |k| [t("issues.status.#{k}"), k] }
  end

  def link_to_create_permalink
    options = {
      class: 'dropdown-item',
      data:  {
        remote: true,
        method: :post,
        toggle: :dropdown
      }
    }

    link_to permalinks_path, options do
      t '.create_permalink'
    end
  end

  def link_to_download_grouped_issue_data
    options = {
      class: 'dropdown-item',
      data:  {
        method: :post,
        toggle: :dropdown
      }
    }

    link_to issues_exports_path(grouped: true), options do
      t '.download_grouped_issue_data'
    end
  end

  def link_to_download_issue_data
    options = {
      class: 'dropdown-item',
      data:  {
        method: :post,
        toggle: :dropdown
      }
    }

    link_to issues_exports_path, options do
      t '.download_issue_data'
    end
  end

  def link_to_download_pdf
    link_to issues_board_path(format: :pdf), class: 'dropdown-item' do
      t '.download_pdf'
    end
  end

  def link_to_download_csv
    link_to issues_board_path(format: :csv), class: 'dropdown-item' do
      t '.download_csv'
    end
  end

  def link_to_destroy_all_issues
    options = {
      class: 'dropdown-item',
      data:  {
        method:  :delete,
        toggle:  :dropdown,
        confirm: t('messages.confirmation')
      }
    }

    link_to t('.destroy_all'), issues_board_destroy_all_path, options
  end
end
