# frozen_string_literal: true

class IssuesController < ApplicationController
  include Issues::Filters

  respond_to :html, :json, :js

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

  def index
    @issues      = issues.order(created_at: :desc).page params[:page]
    @issues      = @issues.active unless filter_default_status?
    @alt_partial = alt_index?
    @stats       = stats if @alt_partial

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

    def alt_index?
      @issues.any?                            &&
        @issues.all?(&:single_row_data_type?) &&
        issues_can_share_headers?
    end

    def issues_can_share_headers?
      header_rows = @issues.map(&:data).map &:first

      if header_rows.all? { |row| row.kind_of?(Hash) }
        sample = header_rows.first.keys.sort

        header_rows.all? { |row| row.keys.sort == sample }
      else
        sample = header_rows.first.sort

        header_rows.all? { |row| row.sort == sample }
      end
    end
end
