# frozen_string_literal: true

class Scripts::VariablesController < ApplicationController
  include Authentication
  include Authorization

  before_action :set_script, :set_variable

  def show
    @versions = @variable.versions.reorder created_at: :desc
  end

  private

    def set_script
      @script = Script.find params[:script_id]
    end

    def set_variable
      @variable = @script.variables.find params[:id]
    end
end
