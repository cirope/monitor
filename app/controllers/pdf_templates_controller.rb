# frozen_string_literal: true

class PdfTemplatesController < ApplicationController
  before_action :authorize
  before_action :set_title, except: [:destroy]
  before_action :set_pdf_template, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @pdf_templates = PdfTemplate.all

    respond_with @pdf_templates
  end

  def show
    respond_with @pdf_template
  end

  def new
    @pdf_template = PdfTemplate.new

    respond_with @pdf_template
  end

  def edit
    respond_with @pdf_template
  end

  def create
    @pdf_template = PdfTemplate.new pdf_template_params

    @pdf_template.save
    respond_with @pdf_template
  end

  def update
    @pdf_template.update pdf_template_params

    respond_with @pdf_template
  end

  def destroy
    @pdf_template.destroy

    respond_with @pdf_template, location: pdf_templates_url
  end

  private

    def pdf_template_params
      params.require(:pdf_template).permit :name, :content, :lock_version
    end

    def set_pdf_template
      @pdf_template = PdfTemplate.find params[:id]
    end
end
