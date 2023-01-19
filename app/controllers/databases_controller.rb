# frozen_string_literal: true

class DatabasesController < ApplicationController
  include Databases::Filters

  before_action :authorize
  before_action :set_title, except: [:destroy]
  before_action :set_account
  before_action :set_database, only: [:show, :edit, :update, :destroy]

  def index
    @databases = databases.ordered.page params[:page]
  end

  def show
  end

  def new
    @database = @account.databases.new
  end

  def edit
  end

  def create
    @database = @account.databases.new database_params

    if @database.save
      redirect_to @database
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @database.update database_params
      redirect_to @database
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @database.destroy

    redirect_to databases_url
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
