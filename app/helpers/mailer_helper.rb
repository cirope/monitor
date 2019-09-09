# frozen_string_literal: true

module MailerHelper
  def render_object_for_email object
    if object.is_a? Hash
      render 'notifier/objects/table', object: object
    else
      render 'notifier/objects/ul', object: object
    end
  end

  def link_to_next_reference
    content_tag :sup do
      link_to "[#{next_reference}]", "#ref-#@reference"
    end
  end

  private

    def next_reference
      @reference ||= 0

      @reference += 1
    end
end
