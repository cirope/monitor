# frozen_string_literal: true

module ActionTitle
  extend ActiveSupport::Concern

  def set_title
    @title = t action_title unless request_js?
  end

  def action_aliases
    { create: 'new', update: 'edit' }.with_indifferent_access
  end

  private

    def action_title
      [controller_path.gsub('/', '.'), action_aliases[action_name] || action_name, 'title'].join '.'
    end

    def request_js?
      request&.xhr? || request&.format == 'text/javascript'
    end
end
