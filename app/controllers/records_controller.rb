# frozen_string_literal: true

class RecordsController < ApplicationController
  include Authentication
  include Authorization
  include Records::Filters

  # GET /records
  def index
    @records       = records.order(created_at: :desc).page params[:page]
    @records_class = @records.first.class
  end

  # GET /records/1
  def show
    @record       = scope.find params[:id]
    @record_class = @record.class
  end
end
