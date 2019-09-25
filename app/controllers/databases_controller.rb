# frozen_string_literal: true

class DatabasesController < ApplicationController
  include Databases::Filters

  before_action :authorize, :not_guest, :not_author
  before_action :set_title, except: [:destroy]
  before_action :set_account
  before_action :set_database, only: [:show, :edit, :update, :destroy]
  before_action :not_supervisor, except: [:index, :show]

  respond_to :html, :json

  def index
    @databases = databases.ordered.page params[:page]

    respond_with @databases
  end

  def show
    respond_with @database
  end

  def new
    @database = @account.databases.new

    respond_with @database
  end

  def edit
    respond_with @database
  end

  def create
    @database = @account.databases.new database_params

    @database.save
    respond_with @database
  end

  def update
    @database.update database_params

    respond_with @database
  end

  def destroy
    @database.destroy

    respond_with @database
  end

  private

    def set_account
      @account = Current.account
    end

    def set_database
      @database = @account.databases.find params[:id]
    end

    def database_params
      params.require(:database).permit :name, :driver, :description,
        properties_attributes: [:id, :key, :value, :_destroy]
    end
end
