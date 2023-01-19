# frozen_string_literal: true

class Rules::ImportsController < ApplicationController
  before_action :authorize
  before_action :set_title, only: [:new]

  def new
  end

  def create
    file = params[:file]

    if file.present?
      Rule.import file.tempfile.path

      redirect_to rules_url, notice: t('.imported')
    else
      redirect_to rules_imports_new_url, alert: t('.no_file')
    end
  rescue => ex
    logger.error ex

    redirect_to rules_url, alert: t('.fail')
  end
end
