# frozen_string_literal: true

module OutputsHelper
  def link_to_error_line object, error, valid: true, **extra_params
    code = content_tag :code, error[:error]
    link = link_to(
      "L##{error[:line]}",
      [:edit, object, extra_params.merge(line: error[:line])]
    ) if valid

    [link, code].compact.join(' | ').html_safe
  end
end
