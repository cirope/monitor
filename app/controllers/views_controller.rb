# frozen_string_literal: true

class ViewsController < ApplicationController
  include Authenticate

  # * POST /views
  def create
    @view = current_user.views.create! issue_id: params[:issue_id]
  end
end
