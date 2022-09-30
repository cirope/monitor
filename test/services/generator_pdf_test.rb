# frozen_string_literal: true

require 'test_helper'

class GeneratorPdfTest < ActiveSupport::TestCase
  test 'raise exception when ruby is used incorrectly' do
    assert_raise(ActionView::Template::Error) do 
      GeneratorPdf.generate '<%= issues_path %>'
    end
  end

  test 'generate string with pdf using bootstrap and ruby' do
    assert_instance_of String,
                       GeneratorPdf.generate('<span class="badge badge-primary"><%= 2 + 2 %></span>')
  end
end
