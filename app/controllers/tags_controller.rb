class TagsController < ApplicationController
  respond_to :html, :json

  before_action :authorize
  before_action :set_title

  # GET /tags
  def index
    @tags = Tag.search query: params[:q], limit: request.xhr? && 10
  end
end
