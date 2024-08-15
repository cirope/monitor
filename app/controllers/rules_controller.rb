# frozen_string_literal: true

class RulesController < ApplicationController
  include Authentication
  include Authorization
  include Rules::Filters
  include Tickets::Scoped

  before_action :set_title, except: [:destroy]
  before_action :set_rule, only: [:show, :edit, :update, :destroy]

  def index
    @rules = rules.order(:id).page params[:page]
  end

  def show
  end

  def new
    @rule = Rule.new
  end

  def edit
  end

  def create
    @rule = Rule.new rule_params.merge(tickets: Array(@ticket))

    if @rule.save
      redirect_to @rule
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @rule.update rule_params
      redirect_to @rule
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @rule.destroy

    redirect_to rules_url
  end

  private
    def set_rule
      @rule = Rule.find params[:id]
    end

    def rule_params
      params.require(:rule).permit :name, :enabled, :lock_version,
        triggers_attributes: [:id, :callback, :_destroy]
    end
end
