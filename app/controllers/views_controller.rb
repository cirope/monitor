# frozen_string_literal: true

class ViewsController < ApplicationController
  before_action :authorize

  respond_to :js

  # * POST /views
  def create
    @view = View.create!(
      user: current_user,
      comment_id: params[:comment_id]
    )
  end
end
