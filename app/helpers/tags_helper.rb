# frozen_string_literal: true

module TagsHelper
  def tag_kinds
    {
      script: Script.model_name.human(count: 0),
      issue:  Issue.model_name.human(count: 0),
      user:   User.model_name.human(count: 0)
    }
  end

  def styles
    styles = %w(secondary primary success info warning danger)

    styles.map { |k| [t("tags.styles.#{k}"), k] }
  end

  def tag_icons tags
    ActiveSupport::SafeBuffer.new.tap do |buffer|
      tags.each do |tag|
        buffer << content_tag(:span, class: "text-#{tag.style}") do
          icon 'fas', 'tag', title: tag.name
        end
      end
    end
  end

  def parent_tags_path tag
    tags_path kind: tag.kind, exclude: tag.id, group: true
  end

  def unlimited_tag_form_edition_for? kind
    kind != 'issue' || !limited_issue_form_edition?
  end

  def effects
    @tag.effects.new if @tag.effects.empty?

    @tag.effects
  end
end
