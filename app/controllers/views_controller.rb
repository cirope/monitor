# frozen_string_literal: true

class ViewsController < ApplicationController
  include Authorization

  before_action :authorize, except: [:create]

  # * POST /views
  def create
    @view = current_user.views.create! issue_id: params[:issue_id]
  end
end
