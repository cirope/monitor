class RulesController < ApplicationController
  include Rules::Filters

  before_action :authorize, :not_guest, :not_security, :not_author
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
    @rule = Rule.new rule_params

    respond_to do |format|
      if @rule.save
        format.html { redirect_to @rule, notice: t('flash.rules.create.notice') }
        format.json { render :show, status: :created, location: @rule }
      else
        format.html { render :new }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rules/1
  def update
    respond_to do |format|
      if update_resource @rule, rule_params
        format.html { redirect_to @rule, notice: t('flash.rules.update.notice') }
        format.json { render :show, status: :ok, location: @rule }
      else
        format.html { render :edit }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rules/1
  def destroy
    respond_to do |format|
      if @rule.destroy
        format.html { redirect_to rules_url, notice: t('flash.rules.destroy.notice') }
        format.json { head :no_content }
      else
        format.html { redirect_to rules_url, alert: t('flash.rules.destroy.alert') }
        format.json { render json: @rule.errors, status: :unprocessable_entity }
      end
    end
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
