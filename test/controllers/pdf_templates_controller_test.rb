# frozen_string_literal: true

require 'test_helper'

class PdfTemplatesControllerTest < ActionController::TestCase
  setup do
    @pdf_template = pdf_templates :first_pdf_template

    login
  end

  teardown do
    Current.account = nil
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should show pdf template' do
    get :show, params: { id: @pdf_template }
    assert_response :success
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should get edit' do
    get :edit, params: { id: @pdf_template }
    assert_response :success
  end

  test 'should create pdf template' do
    counts = [
      'PdfTemplate.count',
      'ActionText::RichText.count'
    ]

    assert_difference counts do
      post :create, params: {
        pdf_template: {
          name: 'Test pdf template',
          content: '<div>new pdf Template</div>'
        }
      }
    end

    assert_redirected_to pdf_template_url(PdfTemplate.last)
  end

  test 'should update pdf template' do
    patch :update, params: {
      id: @pdf_template,
      pdf_template: {
        name: 'Updated pdf template',
        content: '<div>updated pdf Template</div>'
      }
    }

    assert_redirected_to pdf_template_url(@pdf_template)
  end

  test 'should destroy script' do
    @pdf_template = pdf_templates :second_pdf_template

    counts = [
      'PdfTemplate.count',
      'ActionText::RichText.count'
    ]

    assert_difference counts, -1 do
      delete :destroy, params: { id: @pdf_template }
    end

    assert_redirected_to pdf_templates_url
  end
end
