# frozen_string_literal: true

class TicketsController < ApplicationController
  include Authentication
  include Authorization
  include Issues::Filters

  before_action :set_title

  def index
    @issues = Issue.tickets.ordered.page params[:page]
  end
end
