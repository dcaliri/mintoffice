class CardbillsController < ApplicationController

  # GET /cardbills
  # GET /cardbills.xml
  def index
#    @cardbills = Cardbill.paginate(:order => 'transdate desc', :page => params[:page], :per_page => 20)
    @cardbills = Cardbill.search(params[:q]).paginate(:order => 'transdate desc', :page => params[:page], :per_page => 20)
    @cardbills_count = Cardbill.count(:all)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cardbills }
    end
  end

  # GET /cardbills/1
  # GET /cardbills/1.xml
  def show
    @cardbill = Cardbill.find(params[:id])
    @attachments = Attachment.for_me(@cardbill)

    session[:attachments] = [] if session[:attachments].nil?      
    @attachments.each { |at| session[:attachments] << at.id }

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cardbill }
    end
  end

  # GET /cardbills/new
  # GET /cardbills/new.xml
  def new
    @cardbill = Cardbill.new
    @creditcards = Creditcard.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cardbill }
    end
  end

  # GET /cardbills/1/edit
  def edit
    @cardbill = Cardbill.find(params[:id])
    @creditcards = Creditcard.all
    @attachments = Attachment.for_me(@cardbill)
  end

  # POST /cardbills
  # POST /cardbills.xml
  def create
    @cardbill = Cardbill.new(params[:cardbill])
    @creditcards = Creditcard.all

    respond_to do |format|
      if @cardbill.save
        Attachment.save_for(@cardbill,@user,params[:attachment])
        flash[:notice] = I18n.t "common.messages.created", :model => Cardbill.model_name.human
        format.html { redirect_to(@cardbill) }
        format.xml  { render :xml => @cardbill, :status => :created, :location => @cardbill }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cardbill.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /cardbills/1
  # PUT /cardbills/1.xml
  def update
    @cardbill = Cardbill.find(params[:id])
    @creditcards = Creditcard.all

    respond_to do |format|
      if @cardbill.update_attributes(params[:cardbill])
        Attachment.save_for(@cardbill,@user,params[:attachment])
        flash[:notice] = I18n.t("common.messages.updated", :model => Cardbill.model_name.human)
        format.html { redirect_to(@cardbill) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cardbill.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cardbills/1
  # DELETE /cardbills/1.xml
  def destroy
    @cardbill = Cardbill.find(params[:id])
    @cardbill.destroy

    respond_to do |format|
      format.html { redirect_to(cardbills_url) }
      format.xml  { head :ok }
    end
  end
end
