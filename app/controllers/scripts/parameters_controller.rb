# frozen_string_literal: true

class Scripts::ParametersController < ApplicationController
  include Authentication
  include Authorization

  before_action :set_script, :set_parameter

  def show
    @versions = @parameter.versions.reorder created_at: :desc
  end

  private

    def set_script
      @script = Script.find params[:script_id]
    end

    def set_parameter
      @parameter = @script.parameters.find params[:id]
    end
end
