class DescriptorsController < ApplicationController
  before_action :authorize, :not_guest, :not_security, :not_author
  before_action :set_descriptor, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  def index
    @descriptors = Descriptor.all
  end

  def show
  end

  def new
    @descriptor = Descriptor.new
  end

  def edit
  end

  def create
    @descriptor = Descriptor.new descriptor_params

    respond_to do |format|
      if @descriptor.save
        format.html { redirect_to @descriptor, notice: t('flash.actions.create.notice', resource_name: Descriptor.model_name.human) }
        format.json { render :show, status: :created, location: @descriptor }
      else
        format.html { render :new }
        format.json { render json: @descriptor.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if update_resource @descriptor, descriptor_params
        format.html { redirect_to @descriptor, notice: t('flash.actions.update.notice', resource_name: Descriptor.model_name.human) }
        format.json { render :show, status: :ok, location: @descriptor }
      else
        format.html { render :edit }
        format.json { render json: @descriptor.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @descriptor.destroy
        format.html { redirect_to descriptors_url, notice: t('flash.actions.destroy.notice', resource_name: Descriptor.model_name.human) }
        format.json { head :no_content }
      else
        format.html { redirect_to descriptors_url, alert: t('flash.actions.destroy.alert', resource_name: Descriptor.model_name.human) }
        format.json { render json: @descriptor.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_descriptor
      @descriptor = Descriptor.find params[:id]
    end

    def descriptor_params
      params.require(:descriptor).permit :name, :lock_version
    end
end
