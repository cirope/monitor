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
end
