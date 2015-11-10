module IssuesHelper
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
end
