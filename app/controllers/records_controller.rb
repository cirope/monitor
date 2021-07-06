# frozen_string_literal: true

class RecordsController < ApplicationController
  include Records::Filters

  before_action :authorize,
                :not_guest,
                :not_author,
                :not_owner,
                :not_manager

  respond_to :html

  # GET /records
  def index
    @records       = records.order(created_at: :desc).page params[:page]
    @records_class = @records.first.class

    respond_with @records
  end

  # GET /records/1
  def show
    @record = scope.find params[:id]
    @record_class = @record.class
  end
end
