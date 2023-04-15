# frozen_string_literal: true

class IssuesController < ApplicationController
  include Authentication
  include Authorization
  include Issues::Filters

  before_action :set_account, only: [:show, :index]
  before_action :set_script, only: [:index]
  before_action :set_permalink, only: [:show]
  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  before_action :set_context, only: [:show, :edit, :update]
  before_action :set_owner
  before_action :set_title, except: [:destroy]
  before_action -> { request.variant = :graph if params[:graph].present? }

  def index
    @issues = issues.order created_at: :desc

    maybe_paginate_issues

    if @issues.can_collapse_data?
      @alt_partial = true
      @stats       = params[:graph].present? ? graph_stats : stats
      @data_keys   = return_data_keys params, @issues
    end

    respond_to do |format|
      format.any :html, :js, :json
      format.csv { render csv: @issues }
    end
  end

  def show
    @comment = @issue.comments.new
  end

  def new
    @issue = Issue.new
  end

  def edit
  end

  def create
    @issue = Issue.new issue_params
    @issue.owner = @owner if @owner

    if @issue.save
      redirect_to [@owner, @issue, context: @context, filter: params[:filter]&.to_unsafe_h]
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    if @issue.update issue_params
      redirect_to [@owner, @issue, context: @context, filter: params[:filter]&.to_unsafe_h]
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    script        = @issue.script
    filter_params = { filter: params[:filter]&.to_unsafe_h }

    @issue.destroy

    redirect_to @issue.ticket? ?
      [@owner, :tickets, filter_params] :
      script_issues_url(script, filter_params)
  end

  def api_issues
    command_token = Api::V1::AuthenticateUser.call Current.user, Current.account

    @token = command_token.success? ? command_token.result : command_token.errors

    @url = api_v1_script_issues_url params[:script_id],
                                    host: ENV['APP_HOST'], 
                                    protocol: ENV['APP_PROTOCOL']
  end

  private

    def return_data_keys params, issues
      if issues.first.canonical_data.present? &&
         params.dig(:filter, :canonical_data, :keys_ordered).blank?
        issues.first.canonical_data.keys
      elsif params.dig(:filter, :canonical_data, :keys_ordered).present?
        JSON[params[:filter][:canonical_data][:keys_ordered]]
      end
    end

    def maybe_paginate_issues
      @issues = @issues.page params[:page] unless request.format.symbol == :csv
      @issues = @issues.per(6) if skip_default_status? && request.format.symbol != :csv
      @issues = @issues.active unless skip_default_status?
    end

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

    def set_title
      unless request_js?
        model = @issue&.ticket? ? 'tickets' : 'issues'

        @title = t [model, action_aliases[action_name] || action_name, 'title'].join '.'
      end
    end
end
