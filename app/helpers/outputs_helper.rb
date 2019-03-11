# frozen_string_literal: true

module OutputsHelper
  def link_to_error_line script, error, valid
    link = link_to(
      "L##{error[:line]}",
      script_path(script.id, line: error[:line])
    ) if valid

    [link, content_tag(:code, error[:error])].compact.join(' | ').html_safe
  end
end
