# encoding: UTF-8

class AccountsController < ApplicationController
  skip_before_filter :authorize, :only => [:authenticate, :login, :logout]

  layout "application", :except => [:login]
  layout "login", only: [:login, :authenticate]

  before_filter :only => [:show] do |c|
    @account = Account.find(params[:id])
    c.save_attachment_id @account
  end

  before_filter :except => [:my, :show, :changepw, :changepw_form, :login, :authenticate, :edit, :update, :logout, :google_apps] do |c|
    unless current_person.admin?
      flash[:notice] = I18n.t("common.messages.not_allowed")
      redirect_to :root
    end
  end

  def index
    @accounts = Account.check_disabled(params[:disabled]).search(params[:q]).order(:id)
  end

  def new
    @account = Account.new
  end

  def my
    @account = current_person.account
  end

  def edit
    session[:return_to] = request.referer
    @account = Account.find(params[:id])
  end

  def create
    @account = Account.new(params[:account])
    if @account.save
      Boxcar.add_to_boxcar(@account.boxcar_account)
      flash[:notice] = I18n.t("common.messages.created", :model => Account.model_name.human)
      redirect_to :accounts
    else
      render 'new'
    end
  end

  def update
    @account = Account.find(params[:id])
    if @account.update_attributes(params[:account])
      Boxcar.add_to_boxcar(@account.boxcar_account)
      flash[:notice] = I18n.t("common.messages.updated", :model => Account.model_name.human)
      redirect_to session[:return_to]
    else
      render 'edit'
    end
  end

  def authenticate
    account = Account.authenticate(params[:name], params[:password])
    if account
      session[:person_id] = account.person.id
      redirect_to :root
    else
      flash.now[:notice] = t("accounts.login.loginfail")
      render 'login'
    end
  end

  def login
    if current_person.present?
      redirect_to :root, notice: '로그인된 상태에서는 접근할 수 없는 페이지입니다.'
    end
  end

  def logout
    session[:person_id] = nil
    redirect_to(:controller => "main", :action => "index")
  end

  def disable
    @account = Account.find(params[:id])
    @account.disable
    redirect_to :accounts
  end

  def changepw_form
    session[:return_to] = session[:return_to] || request.referer
  end

  def changepw
    account = Account.find(params[:id])
    password  = params[:password]
    password_confirmation = params[:password_confirmation]

    if password.blank? and password_confirmation.blank?
      redirect_to [:changepw, account], notice: I18n.t("accounts.changepw.password_confirm_blank")
    elsif password != password_confirmation
      redirect_to [:changepw, account], notice: I18n.t("accounts.changepw.password_confirm_wrong")
    else
      account.password = password
      account.save
      flash[:notice] = I18n.t("accounts.changepw.successfully_changed")

      return_to = session[:return_to]
      session[:return_to] = nil

      redirect_to return_to
    end
  end

  def loginas
    account = Account.find(params[:id])
    session[:person_id] = account.person.id
    redirect_to :root
  end

  def google_apps
    @accounts = Account.has_google_apps_account
  rescue  => e
    logger.info "find_google_apps failed: #{e.message}"
    redirect_to :back, alert: 'Access fails to google apps'
  end

  def create_google_apps
    @account = Account.find(params[:id])
    if @account.create_google_app_account
      redirect_to :back, notice: t('controllers.accounts.create_google')
    else
      redirect_to :back, alert: t('controllers.accounts.fail_create_google')
    end
  end

  def remove_google_apps
    @account = Account.find(params[:id])
    if @account.remove_google_app_account
      redirect_to :back, notice: t('controllers.accounts.remove_google')
    else
      redirect_to :back, alert: t('controllers.accounts.fail_remove_google')
    end
  end

  def create_redmine
    @account = Account.find(params[:id])
    redmine = @account.create_redmine_account
    redirect_to :back, notice: t('controllers.accounts.create_redmine')
  rescue => e
    logger.info "created_redmine failed: #{e.message}"
    redirect_to :back, alert: t('controllers.accounts.fail_create_redmine', message: e.message)
  end

  def remove_redmine
    @account = Account.find(params[:id])
    @account.remove_redmine_account
    redirect_to :back, notice: t('controllers.accounts.remove_redmine')
  rescue => e
    logger.info "remove_redmine failed: #{e.message}"
    redirect_to :back, alert: t('controllers.accounts.fail_remove_redmine', message: e.message)
  end
end