# frozen_string_literal: true

class IssuesController < ApplicationController
  include Issues::Filters

  respond_to :html, :json, :js, :csv

  before_action :authorize
  before_action :not_guest, except: [:index, :show]
  before_action :not_author, :not_manager, only: [:destroy]
  before_action :not_security, :not_owner, except: [:index, :show, :edit, :update]
  before_action :set_title, except: [:destroy]
  before_action :set_account, only: [:show, :index]
  before_action :set_script, only: [:index]
  before_action :set_permalink, only: [:show]
  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  before_action :set_context, only: [:show, :edit, :update]
  before_action -> { request.variant = :graph if params[:graph].present? }

  def index
    @issues      = issues.order(created_at: :desc).page params[:page]
    @issues      = skip_default_status? ? @issues.per(6) : @issues.active
    @alt_partial = @issues.can_collapse_data?
    @stats       = params[:graph].present? ? graph_stats : stats if @alt_partial

    respond_with @issues
  end

  def show
    @comment = @issue.comments.new

    respond_with @issue
  end

  def edit
    respond_with @issue
  end

  def update
    @issue.update issue_params

    respond_with @issue, location: issue_url(@issue, context: @context, filter: params[:filter]&.to_unsafe_h)
  end

  def destroy
    @issue.destroy

    respond_with @issue, location: script_issues_url(@issue.script, filter: params[:filter]&.to_unsafe_h)
  end

  def api_issues
    command_token = Api::V1::AuthenticateUser.call Current.user, Current.account, 1.month.from_now

    @token = command_token.success? ? command_token.result : command_token.errors

    @url = api_v1_script_issues_url params[:script_id],
                                    host: ENV['APP_HOST'], 
                                    protocol: ENV['APP_PROTOCOL']
  end

  private

    def set_issue
      @issue = scoped_issues.find params[:id]
    end

    def set_account
      if params[:account_id]
        account = Account.find_by! tenant_name: params[:account_id]

        session[:tenant_name] = account.tenant_name

        redirect_to_action account
      end
    end

    def set_script
      @script = Script.find params[:script_id] if params[:script_id]
    end

    def set_permalink
      @permalink = Permalink.find_by! token: params[:permalink_id] if params[:permalink_id]
    end

    def set_context
      @context = params[:context] == 'board' ? :board : :issues
    end

    def redirect_to_action account
      if params[:id]
        account.switch { set_issue }

        redirect_to issue_url(@issue, filter: params[:filter]&.to_unsafe_h)
      elsif params[:script_id]
        account.switch { set_script }

        redirect_to script_issues_url(@script, filter: params[:filter]&.to_unsafe_h)
      end
    end

    def stats
      issues.group("(#{Issue.table_name}.data ->>1)::json->>-1", :status).count
    end

    def graph_stats
      case params[:graph]
      when 'status'
        issues.group(:status).count.inject({}) do |counts, (status, count)|
          counts.merge t("issues.status.#{status}") => count
        end
      when 'tags'
        issues_by_tags(false).group("#{Tag.table_name}.name").count
      when 'final_tags'
        issues_by_tags(true).group("#{Tag.table_name}.name").count
      else
        issues.group("(#{Issue.table_name}.data ->>1)::json->>-1").count
      end
    end

    def issues_by_tags final
      issues.left_joins(:tags).merge(Tag.final final).or(
        issues.left_joins(:tags).where tags: { id: nil }
      )
    end
end
