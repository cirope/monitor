# frozen_string_literal: true

class TicketsController < ApplicationController
  include Authentication
  include Authorization
  include Issues::Filters

  before_action :set_title, :set_owner

  def index
    @issues = (@owner || Issue).tickets.ordered.page params[:page]
  end
end
