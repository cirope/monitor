class IssuesController < ApplicationController
  include Issues::Filters

  before_action :authorize
  before_action :not_guest, except: [:index, :show]
  before_action :not_author, only: [:destroy]
  before_action :not_security, except: [:index, :show, :edit, :update]
  before_action :set_title, except: [:destroy]
  before_action :set_script, only: [:index]
  before_action :set_permalink, only: [:show]
  before_action :set_account, only: [:show]
  before_action :set_issue, only: [:show, :edit, :update, :destroy]
  before_action :set_context, only: [:show, :edit, :update]

  respond_to :html, :json, :js

  def index
    @issues = issues.order(created_at: :desc).page params[:page]
    @issues = @issues.active unless filter_default_status?

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

    respond_with @issue, location: issue_url(@issue, context: @context)
  end

  def destroy
    @issue.destroy

    respond_with @issue, location: script_issues_url(@issue.script, filter: params[:filter]&.to_unsafe_h)
  end

  private

    def set_issue
      @issue = issues.find params[:id]
    end

    def set_account
      if params[:account_id]
        account = Account.find_by! tenant_name: params[:account_id]

        account.switch { set_issue }

        session[:tenant_name] = account.tenant_name

        redirect_to issue_url(@issue)
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
end
