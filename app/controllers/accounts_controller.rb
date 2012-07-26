# encoding: UTF-8

class AccountsController < ApplicationController
  skip_before_filter :authorize, :only => [:login, :logout]
  layout "application", :except => [:login]
  layout "login", only: [:login]

  before_filter :only => [:show] do |c|
    @this_account = Account.find(params[:id])
    c.save_attachment_id @this_account
  end

  before_filter :except => [:my, :changepw, :login, :edit, :update, :logout, :google_apps] do |c|
    unless current_account.admin?
      flash[:notice] = I18n.t("common.messages.not_allowed")
      redirect_to :controller => "main", :action => "index"
    end
  end

  def index
    @accounts = Account.check_disabled(params[:disabled]).search(params[:q]).order(:id)
  end

  def logout
    session[:account_id] = nil
    redirect_to(:controller => "main", :action => "index")
  end

  def login
    if request.post?
      account = Account.authenticate(params[:name], params[:password])
      if account
        session[:account_id] = account.id
        redirect_to(:controller => "main", :action => "index")
      else
        flash.now[:notice] = t("accounts.login.loginfail")
      end
    end
  end

  def disable
    @this_account = Account.find(params[:id])
    @this_account.disable
    redirect_to :action => "index"
  end

  def new
    @this_account = Account.new
  end

  def edit
    session[:return_to] = request.referer
    @this_account = Account.find(params[:id])
  end

  def create
    @this_account = Account.new(params[:account])
    @this_account.companies << current_company
    if @this_account.save
      Boxcar.add_to_boxcar(@this_account.boxcar_account) unless @this_account.boxcar_account.empty?
      flash[:notice] = I18n.t("common.messages.created", :model => Account.model_name.human)
      redirect_to :action => 'index'
    else
      render :action => "new"
    end
  end

  def update
    @this_account = Account.find(params[:id])

    if @this_account.update_attributes(params[:account])
      logger.info @this_account.changes
      Boxcar.add_to_boxcar(@this_account.boxcar_account) if ! @this_account.boxcar_account.empty?

      flash[:notice] = I18n.t("common.messages.updated", :model => Account.model_name.human)
      redirect_to session[:return_to]
    else
      render :action => "edit"
    end
  end

  def google_apps
    @accounts = Account.has_google_apps_account
  end

  def create_google_apps
    @this_account = Account.find(params[:id])
    if @this_account.create_google_app_account
      redirect_to :back, notice: t('controllers.accounts.create_google')
    else
      redirect_to :back, alert: t('controllers.accounts.fail_create_google')
    end
  end

  def remove_google_apps
    @this_account = Account.find(params[:id])
    if @this_account.remove_google_app_account
      redirect_to :back, notice: t('controllers.accounts.remove_google')
    else
      redirect_to :back, alert: t('controllers.accounts.fail_remove_google')
    end
  end

  def create_redmine
    @this_account = Account.find(params[:id])
    redmine = @this_account.create_redmine_account
    redirect_to :back, notice: t('controllers.accounts.create_redmine')
  rescue => e
    logger.info "created_redmine failed: #{e.message}"
    redirect_to :back, alert: t('controllers.accounts.fail_create_redmine', message: e.message)
  end

  def remove_redmine
    @this_account = Account.find(params[:id])
    @this_account.remove_redmine_account
    redirect_to :back, notice: t('controllers.accounts.remove_redmine')
  rescue => e
    logger.info "remove_redmine failed: #{e.message}"
    redirect_to :back, alert: t('controllers.accounts.fail_remove_redmine', message: e.message)
  end

  def changepw
    if request.post?
      this_account = Account.find(params[:account_id])
      if  params[:password] != params[:password_confirmation]
         flash.now[:notice] = I18n.t("accounts.changepw.password_confirm_wrong")
       end
       unless flash.now[:notice]
         this_account.password = params[:password]
         this_account.save
         flash[:notice] = I18n.t("accounts.changepw.successfully_changed")
         if current_account.ingroup? "admin"
           redirect_to(:action => "index")
         else
           redirect_to accounts_my_path()
         end
       end
     end
  end

  def loginas
    target_account = Account.find(params[:id])
    session[:account_id] = target_account.id
    redirect_to(:controller => "main", :action => "index")
  end
end
