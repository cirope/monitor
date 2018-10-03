class TagsController < ApplicationController
  before_action :authorize
  before_action :not_guest, :not_author, :not_security, except: [:index]
  before_action :set_title, except: [:destroy]
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @tags = scope.search(query: params[:q]).limit(request.xhr? && 10).order(:name).page params[:page]

    respond_with @tags
  end

  def show
    respond_with @tag
  end

  def new
    @tag = scope.new

    respond_with @tag
  end

  def edit
    respond_with @tag
  end

  def create
    @tag = scope.new tag_params

    @tag.save
    respond_with @tag, location: [@tag, kind: @tag.kind]
  end

  def update
    @tag.update tag_params

    respond_with @tag, location: [@tag, kind: @tag.kind]
  end

  def destroy
    @tag.destroy

    respond_with @tag
  end

  private

    def set_tag
      @tag = scope.find params[:id]
    end

    def tag_params
      params.require(:tag).permit :name, :style, :final, :export, :lock_version
    end

    def scope
      Tag.where(kind: params[:kind])
    end
end
