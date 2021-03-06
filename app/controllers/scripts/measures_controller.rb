# frozen_string_literal: true

class Scripts::MeasuresController < ApplicationController
  before_action :authorize, :not_guest, :not_security
  before_action :set_title, :set_script

  respond_to :html

  def index
    @measures = measures.preload(:measurable).reorder(created_at: :desc).page params[:page]

    respond_with @measures
  end

  private

    def set_script
      @script = Script.find params[:script_id]
    end

    def measures
      case params[:type]
      when 'execution'
        @script.execution_measures
      when 'run'
        @script.run_measures
      end
    end
end
