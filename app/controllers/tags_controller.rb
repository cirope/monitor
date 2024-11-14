# frozen_string_literal: true

class TagsController < ApplicationController
  include Authentication
  include Authorization

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

    if @tag.save
      redirect_to [@tag, kind: @tag.kind]
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @tag.update tag_params
      redirect_to [@tag, kind: @tag.kind]
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy

    redirect_to tags_url
  end

  private

    def set_tag
      @tag = scope.find params[:id]
    end

    def tag_params
      params.require(:tag).permit :name, :style, :final, :group, :category, :export,
        :parent_id, :editable, :recovery, :hide, :lock_version,
        effects_attributes: [:id, :implied_id, :_destroy]
    end

    def scope
      kind  = current_user.manager? ? 'issue' : params[:kind]
      scope = Tag.where kind: kind
      scope = scope.group_option true              if params[:group].present?
      scope = scope.where.not id: params[:exclude] if params[:exclude].present?

      scope
    end
end
