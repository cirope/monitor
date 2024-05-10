# frozen_string_literal: true

class Rules::RevertsController < ApplicationController
  include Authentication
  include Authorization

  before_action :set_rule, :check_if_can_edit

  def create
    @version = @rule.trigger_versions.find params[:id]

    if @rule.revert_to @version
      redirect_to @rule, notice: t('.reverted')
    else
      redirect_to rule_version_path(@rule.id, @version.id), alert: t('.cannot_be_reverted')
    end
  end

  private

    def set_rule
      @rule = Rule.find params[:rule_id]
    end

    def check_if_can_edit
      unless current_user.can? :edit, 'rules'
        redirect_to rules_url, alert: t('messages.not_allowed')
      end
    end
end
