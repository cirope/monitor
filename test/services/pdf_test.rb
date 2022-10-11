# frozen_string_literal: true

require 'test_helper'

class PdfTest < ActiveSupport::TestCase
  test 'raise exception when use a variable undefined' do
    assert_raise(ActionView::Template::Error) do
      Pdf.generate '<%= var %>'
    end
  end

  test 'generate string with pdf using bootstrap, locals and options' do
    pdf_string = Pdf.generate '<span class="badge badge-primary"><%= 2 + 2 %>:<%= var %></span>',
                              locals: { var: 'test' },
                              options: { orientation: 'Landscape' }

    assert_instance_of String, pdf_string
  end
end
