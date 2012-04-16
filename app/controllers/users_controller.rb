class UsersController < ApplicationController
  layout "application", :except => ["login"]

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

  def my
  end
  # GET /users
  # GET /users.xml
  def index
    unless @user.ingroup? "admin"
      flash[:notice] = I18n.t("common.messages.not_allowed")
      redirect_to :controller => "main", :action => "index"
      return
    end

    if params[:disabled] == 'on'
      @users = User.search(params[:q]).find(:all, :order => :id, :conditions => "name LIKE '[X] %'")
    else
      @users = User.search(params[:q]).find(:all, :order => :id, :conditions => "name NOT LIKE '[X] %'")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @this_user = User.find(params[:id])
    @attachments = Attachment.for_me(@this_user.hrinfo) if @this_user.hrinfo

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @this_user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @hrinfo = Hrinfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @attachments = Attachment.for_me(@user.hrinfo) if @user.hrinfo
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @hrinfo = Hrinfo.new(params[:hrinfo])
    respond_to do |format|
      if @user.save
#        @user.hrinfo = @hrinfo
        @attachment = Attachment.new(params[:attachment])
        @attachment.save_for(@hrinfo,@user)
        flash[:notice] = "User #{@user.name}was successfully created."
        format.html { redirect_to(:action => 'index') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "User #{@user.name}was successfully updated."
        format.html { redirect_to(:action => 'index') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    if Integer(params[:id]) != session[:user_id]
      @user = User.find(params[:id])
      @user.destroy
    end

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  def changepw
    if request.post?
      this_user = User.find(params[:user_id])
      if  params[:password] != params[:password_confirmation]
         flash.now[:notice] = I18n.t("users.changepw.password_confirm_wrong")
       else
         unless @user.ingroup? "admin"
           unless User.authenticate(this_user.name, params[:oldpassword])
             flash.now[:notice] = I18n.t("users.changepw.oldpassword_wrong")
           end
          end
       end
       unless flash.now[:notice]
         this_user.password = params[:password]
         this_user.save
         flash[:notice] = I18n.t("users.changepw.successfully_changed")
         if @user.ingroup? "admin"
           redirect_to(:action => "index")
         else
           redirect_to(:action => "my")
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
