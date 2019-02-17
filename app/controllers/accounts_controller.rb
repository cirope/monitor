class AccountsController < ApplicationController
  respond_to :html

  before_action :authorize, :not_guest
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  before_action :set_title, except: [:destroy]
  before_action :not_author, only: [:edit, :update, :destroy]

  # GET /accounts
  def index
    @accounts = Account.order(:tenant_name).page params[:page]

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

    @account.enroll current_user if @account.save

    respond_with @account
  end

  # PATCH/PUT /accounts/1
  def update
    update_resource @account, account_params

    respond_with @account
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy

    respond_with @account
  end

  private

    def set_account
      @account = Account.find params[:id]
    end

    def account_params
      params.require(:account).permit :name, :tenant_name, :lock_version
    end
end
