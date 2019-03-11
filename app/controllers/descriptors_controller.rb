# frozen_string_literal: true

class DescriptorsController < ApplicationController
  before_action :authorize, :not_guest, :not_security, :not_author
  before_action :set_descriptor, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  respond_to :html, :json

  def index
    @descriptors = Descriptor.all

    respond_with @descriptors
  end

  def show
    respond_with @descriptor
  end

  def new
    @descriptor = Descriptor.new

    respond_with @descriptor
  end

  def edit
    respond_with @descriptor
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
