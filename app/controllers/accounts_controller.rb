# frozen_string_literal: true

class AccountsController < ApplicationController
  include Authentication
  include Authorization
  include Accounts::Filters

  before_action :from_default_account
  before_action :set_account, only: [:show, :edit, :update]
  before_action :set_title

  # GET /accounts
  def index
    @accounts = accounts.order(:tenant_name).page params[:page]
  end

  # GET /accounts/1
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  def create
    @account = Account.new account_params

    Account.transaction do
      if @account.save
        @account.enroll current_user, copy_user: true

        redirect_to @account
      else
        render 'new', status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update account_params
      redirect_to @account
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

    def set_account
      @account = Account.find_by! tenant_name: params[:id]
    end

    def account_params
      params.require(:account).permit :name, :tenant_name, :style,
        :group_issues_by_schedule, :token_interval, :token_frequency, :lock_version
    end

    def from_default_account
      not_authorized_redirect !current_account.default?
    end
end
