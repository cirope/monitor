class TagsController < ApplicationController
  before_action :authorize, :not_guest
  before_action :set_title, except: [:destroy]
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @tags = Tag.search(query: params[:q], limit: request.xhr? && 10).order(:name).page params[:page]

    respond_with @tags
  end

  def show
    respond_with @tag
  end

  def new
    @tag = Tag.new

    respond_with @tag
  end

  def edit
  end

  def create
    @tag = Tag.new tag_params

    @tag.save
    respond_with @tag
  end

  def update
    @tag.update tag_params
    respond_with @tag
  end

  def destroy
    @tag.destroy
    respond_with @tag
  end

  private

    def set_tag
      @tag = Tag.find params[:id]
    end

    def tag_params
      params.require(:tag).permit :name, :lock_version
    end
end
