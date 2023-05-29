# frozen_string_literal: true

class AccountsController < ApplicationController
  include Accounts::Filters

  respond_to :html

  before_action :authorize,
                :not_guest,
                :not_owner,
                :not_manager,
                :not_author,
                :from_default_account

  before_action :set_account, only: [:show, :edit, :update]
  before_action :set_title

  # GET /accounts
  def index
    @accounts = accounts.order(:tenant_name).page params[:page]

    respond_with @accounts
  end

  # GET /accounts/1
  def show
    respond_with @account
  end

  # GET /accounts/new
  def new
    @account = Account.new

    respond_with @account
  end

  # GET /accounts/1/edit
  def edit
    respond_with @account
  end

  # POST /accounts
  def create
    @account = Account.new account_params

    Account.transaction do
      @account.enroll current_user, copy_user: true if @account.save
    end

    respond_with @account
  end

  # PATCH/PUT /accounts/1
  def update
    update_resource @account, account_params

    respond_with @account
  end

  private

    def set_account
      @account = Account.find_by! tenant_name: params[:id]
    end

    def account_params
      params.require(:account).permit :name, :tenant_name, :style,
        :group_issues_by_schedule, :lock_version
    end

    def from_default_account
      not_authorized_redirect !current_account.default?
    end
end
