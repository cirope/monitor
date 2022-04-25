# frozen_string_literal: true

class SeriesController < ApplicationController
  before_action :authorize
  before_action :set_title
  before_action :set_serie, only: [:show]

  respond_to :html

  # GET /series
  def index
    @series = Serie.limit(100).page params[:page]

    respond_with @series
  end

  # GET /series/1
  def show
  end

  private

    def set_serie
      @serie = Serie.find params[:id]
    end
end
