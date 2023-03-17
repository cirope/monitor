# frozen_string_literal: true

class DescriptorsController < ApplicationController
  include Authorization

  before_action :set_descriptor, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]

  def index
    @descriptors = Descriptor.all.page params[:page]
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

    if @descriptor.save
      redirect_to @descriptor
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @descriptor.update descriptor_params
      redirect_to @descriptor
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @descriptor.destroy

    redirect_to descriptors_url
  end

  private

    def set_descriptor
      @descriptor = Descriptor.find params[:id]
    end

    def descriptor_params
      params.require(:descriptor).permit :name, :public, :lock_version
    end
end
