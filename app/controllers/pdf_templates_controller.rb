# frozen_string_literal: true

class PdfTemplatesController < ApplicationController
  before_action :authorize
  before_action :set_title, except: [:destroy]
  before_action :set_pdf_template, only: [:show, :edit, :update, :destroy]

  def index
    @pdf_templates = PdfTemplate.order(:id).page params[:page]
  end

  def show
  end

  def new
    @pdf_template = PdfTemplate.new
  end

  def edit
  end

  def create
    @pdf_template = PdfTemplate.new pdf_template_params

    if @pdf_template.save
      redirect_to @pdf_template
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @pdf_template.update pdf_template_params
      redirect_to @pdf_template
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @pdf_template.destroy

    redirect_to pdf_templates_url
  end

  private

    def pdf_template_params
      params.require(:pdf_template).permit :name, :content, :lock_version
    end

    def set_pdf_template
      @pdf_template = PdfTemplate.find params[:id]
    end
end
