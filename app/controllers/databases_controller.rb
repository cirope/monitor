class DatabasesController < ApplicationController
  include Databases::Filters

  before_action :authorize, :not_guest, :not_author
  before_action :set_title, except: [:destroy]
  before_action :set_database, only: [:show, :edit, :update, :destroy]
  before_action :not_supervisor, except: [:index, :show]

  def index
    @databases = databases.ordered.page params[:page]
  end

  def show
  end

  def new
    @database = Database.new
  end

  def edit
  end

  def create
    @database = Database.new database_params

    respond_to do |format|
      if @database.save
        format.html { redirect_to @database, notice: t('flash.databases.create.notice') }
        format.json { render :show, status: :created, location: @database }
      else
        format.html { render :new }
        format.json { render json: @database.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /databases/1
  def update
    respond_to do |format|
      if update_resource @database, database_params
        format.html { redirect_to @database, notice: t('flash.databases.update.notice') }
        format.json { render :show, status: :ok, location: @database }
      else
        format.html { render :edit }
        format.json { render json: @database.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /databases/1
  def destroy
    respond_to do |format|
      if @database.destroy
        format.html { redirect_to databases_url, notice: t('flash.databases.destroy.notice') }
        format.json { head :no_content }
      else
        format.html { redirect_to databases_url, alert: t('flash.databases.destroy.alert') }
        format.json { render json: @database.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_database
      @database = Database.find params[:id]
    end

    def database_params
      params.require(:database).permit :name, :driver, :description,
        properties_attributes: [:id, :key, :value, :_destroy]
    end
end
