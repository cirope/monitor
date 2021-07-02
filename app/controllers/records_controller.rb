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
    @class_records = @records.first.class

    respond_with @records
  end

  def show
    @record = scope.find params[:id]
  end
end
