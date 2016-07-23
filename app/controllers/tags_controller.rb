class TagsController < ApplicationController
  before_action :authorize, :not_guest
  before_action :not_author, :not_security, except: [:index]
  before_action :set_title, except: [:destroy]
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = scope.search(query: params[:q]).limit(request.xhr? && 10).order(:name).page params[:page]
  end

  def show
  end

  def new
    @tag = scope.new
  end

  def edit
  end

  def create
    @tag = scope.new tag_params

    respond_to do |format|
      if @tag.save
        format.html { redirect_to [@tag, kind: @tag.kind], notice: t('flash.tags.create.notice') }
        format.json { render :show, status: :created, location: [@tag, kind: @tag.kind] }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if update_resource @tag, tag_params
        format.html { redirect_to [@tag, kind: @tag.kind], notice: t('flash.tags.update.notice') }
        format.json { render :show, status: :ok, location: [@tag, kind: @tag.kind] }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @tag.destroy
        format.html { redirect_to tags_url(kind: @tag.kind), notice: t('flash.tags.destroy.notice') }
        format.json { head :no_content }
      else
        format.html { redirect_to tags_url(kind: @tag.kind), alert: t('flash.tags.destroy.alert') }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
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
