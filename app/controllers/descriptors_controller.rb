class DescriptorsController < ApplicationController
  before_action :authorize, :not_guest, :not_security
  before_action :set_descriptor, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  respond_to :html, :json

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
    @descriptor = Descriptor.new(descriptor_params)

    @descriptor.save
    respond_with @descriptor
  end

  def update
    update_resource @descriptor, descriptor_params
    respond_with @descriptor
  end

  def destroy
    @descriptor.destroy
    respond_with @descriptor
  end

  private

    def set_descriptor
      @descriptor = Descriptor.find params[:id]
    end

    def descriptor_params
      params.require(:descriptor).permit :name, :lock_version
    end
end
