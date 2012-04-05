class DocumentsController < ApplicationController
  # GET /documents
  # GET /documents.xml
  def index
    #@documents = @user.documents.find(:all, :order => "created_at DESC")
    # @documents = Document.all
    q = params[:q]
    if q.nil?
      q = ""
    end
    @documents = @user.documents.find(:all,:conditions => ["title like ?", "%"+q+"%"],:order => 'id desc').paginate(:page => params[:page], :per_page => 20)
    @documents_count = @user.documents.count(:all,:conditions => ["title like ?", "%"+q+"%"])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.xml
  def show
    @document = Document.find(params[:id])
    unless @document.users.include? @user
      flash[:notice] = I18n.t ("permissions.permission_denied")
      redirect_to :controller => "main", :action => "index"
      return
    end
    @attachments = Attachment.for_me(@document)
    session[:attachments] = [] if session[:attachments].nil?      
    @attachments.each { |at| session[:attachments] << at.id }
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @document }
    end
  end
  
  def add_owner
    owner = User.find_by_name(params[:username]);
    document = Document.find(params[:id])
    if owner
      if document.users.include? (owner)
        flash[:notice] = 'Already exists'
      else
        document.users << owner
      end
    else
      flash[:notice] = 'No such user'
    end
    
    redirect_to :action => "edit", :id => document
  end
  
  def remove_owner
    owner = User.find(params[:uid])
    document = Document.find(params[:id])
    document.users.delete(owner)
    
    redirect_to :action => "edit", :id => document
  end
  
  def add_tag
    tag = Tag.find_or_create_by_name(params[:tagname])
    document = Document.find(params[:id])
    if document.tags.include?(tag)
      flash[:notice] = 'Already exists'
    else
      document.tags << tag
    end
    
    redirect_to :action => "edit", :id => document
  end
  
  def remove_tag
    tag = Tag.find(params[:tid])
    document = Document.find(params[:id])
    document.tags.delete(tag)
    
    redirect_to :action => "edit", :id => document    
  end
  # GET /documents/new
  # GET /documents/new.xml
  def new
    @document = Document.new
    @attachment = Attachment.new
    @projects = Project.find(:all, :order => "name ASC")

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @document }
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id])
    @attachments = Attachment.for_me(@document)
    @projects = Project.find(:all, :order => "name ASC")
  end

  # POST /documents
  # POST /documents.xml
  def create
    @document = Document.new(params[:document])
    @document.users << @user
    unless params[:tag].blank?
      tags = params[:tag].split(',')
      tags.each do |tag|
        t = Tag.find_or_create_by_name(tag)
        @document.tags << t
      end
    end
    
    respond_to do |format|
      if @document.save
        Attachment.save_for(@document,@user,params[:attachment])
        flash[:notice] = t('common.messages.created', :model => Document.human_name)
        format.html { redirect_to(@document) }
        format.xml  { render :xml => @document, :status => :created, :location => @document }
      else
        @projects = Project.find(:all, :order => "name ASC")
        format.html { render :action => "new" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.xml
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        Attachment.save_for(@document,@user,params[:attachment])
        flash[:notice] = t('common.messages.updated', :model => Document.human_name)
        format.html { redirect_to(@document) }
        format.xml  { head :ok }
      else
        @projects = Project.find(:all, :order => "name ASC")
        format.html { render :action => "edit" }
        format.xml  { render :xml => @document.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.xml
  def destroy
    @document = Document.find(params[:id])
    @attachments = Attachment.for_me(@document)
    @attachments.each do |attach| attach.destroy end
    @document.destroy

    respond_to do |format|
      format.html { redirect_to(documents_url) }
      format.xml  { head :ok }
    end
  end
end
