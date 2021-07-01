# frozen_string_literal: true

class RecordsController < ApplicationController
  include Records::Filters

  before_action :authorize, :not_guest, :not_author, :not_owner, :not_manager

  respond_to :html, :json

  # GET /records
  def index
    @records = records.limit(request.xhr? && 10).order(created_at: :desc).page params[:page]

    respond_with @records
  end

  def show
    @record = scope.find params[:id]
  end
end
