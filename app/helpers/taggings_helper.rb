# frozen_string_literal: true

module TaggingsHelper
  def tagging_tags group_name
    Tag.joins(:parent).where(parents_tags: { name: group_name }).map do |tag|
      [tag.name, tag.id]
    end
  end

  def issue_tag_kind issue
    issue.ticket? ? 'ticket': 'issue'
  end
end
