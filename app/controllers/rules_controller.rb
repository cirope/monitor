class RulesController < ApplicationController
  before_action :set_title, except: [:destroy]
  before_action :set_rule, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @rules = Rule.search(query: params[:q], limit: request.xhr? && 10).order(:id).page params[:page]

    respond_with @rules
  end

  def show
    respond_with @rule
  end

  def new
    @rule = Rule.new

    respond_with @rule
  end

  def edit
  end

  def create
    @rule = Rule.new rule_params

    @rule.save
    respond_with @rule
  end

  def update
    @rule.update rule_params
    respond_with @rule
  end

  def destroy
    @rule.destroy
    respond_with @rule
  end

  private
    def set_rule
      @rule = Rule.find params[:id]
    end

    def rule_params
      params.require(:rule).permit :name, :enabled, :lock_version
    end
end
