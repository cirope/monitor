# frozen_string_literal: true

require 'test_helper'

class PdfTemplateTest < ActiveSupport::TestCase
  setup do
    @pdf_template = pdf_templates :first_pdf_template
  end

  test 'invalid because name blank' do
    @pdf_template.name = ''

    assert @pdf_template.invalid?
    assert_error @pdf_template, :name, :blank
  end

  test 'invalid because name too long' do
    @pdf_template.name = 'abc' * 250

    assert @pdf_template.invalid?
    assert_error @pdf_template, :name, :too_long, count: 255
  end

  test 'invalid because name taken' do
    @pdf_template.name = 'seConD pDf tEmpLate'

    assert @pdf_template.invalid?
    assert_error @pdf_template, :name, :taken
  end

  test 'invalid because content blank' do
    @pdf_template.content.body = ''

    assert @pdf_template.invalid?
    assert_error @pdf_template, :content, :blank
    assert_error @pdf_template, :base, :content_blank
  end
end
