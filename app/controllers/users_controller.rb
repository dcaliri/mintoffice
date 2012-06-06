class UsersController < ApplicationController
  layout "application", :except => ["login"]
  before_filter :only => [:show] do |c|
    @this_user = User.find(params[:id])
    c.save_attachment_id @this_user
  end
  before_filter :except => [:my, :login] do |c|
    unless @user.admin?
      flash[:notice] = I18n.t("common.messages.not_allowed")
      redirect_to :controller => "main", :action => "index"
      return
    end
  end

  def index
    if params[:disabled] == 'on'
      @users = User.disabled.search(params[:q]).order(:id)
    else
      @users = User.enabled.search(params[:q]).order(:id)
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to(:controller => "main", :action => "index")
  end

  def login
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        redirect_to(:controller => "main", :action => "index")
      else
        flash.now[:notice] = t("users.login.loginfail")
      end
    end
  end

  def disable
    @this_user = User.find(params[:id])
    @this_user.disable
    redirect_to :action => "index"
  end

  def new
    @this_user = User.new
  end

  def edit
    @this_user = User.find(params[:id])
  end

  def create
    @this_user = User.new(params[:user])
    if @this_user.save
      Boxcar.add_to_boxcar(@this_user.boxcar_account) unless @this_user.boxcar_account.empty?
      flash[:notice] = I18n.t("common.messages.created", :model => User.model_name.human)
      redirect_to :action => 'index'
    else
      render :action => "new"
    end
  end

  def update
    @this_user = User.find(params[:id])
      
    if @this_user.update_attributes(params[:user])
      logger.info @this_user.changes
      Boxcar.add_to_boxcar(@this_user.boxcar_account) if ! @this_user.boxcar_account.empty?
      
      flash[:notice] = I18n.t("common.messages.updated", :model => User.model_name.human)
      redirect_to user_path(@this_user)
    else
      render :action => "edit"
    end
  end

  def changepw
    if request.post?
      this_user = User.find(params[:user_id])
      if  params[:password] != params[:password_confirmation]
         flash.now[:notice] = I18n.t("users.changepw.password_confirm_wrong")
       end
       unless flash.now[:notice]
         this_user.password = params[:password]
         this_user.save
         flash[:notice] = I18n.t("users.changepw.successfully_changed")
         if @user.ingroup? "admin"
           redirect_to(:action => "index")
         else
           redirect_to users_my_path()
         end
       end
     end
  end

  def loginas
    target_user = User.find(params[:id])
    session[:user_id] = target_user.id
    redirect_to(:controller => "main", :action => "index")
  end
end
