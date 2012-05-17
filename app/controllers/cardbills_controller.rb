class CardbillsController < ApplicationController
  before_filter :only => [:show] do |c|
    @cardbill = Cardbill.find(params[:id])
    c.save_attachment_id @cardbill
  end

  before_filter :check_access, except: [:index, :new, :create]
  def check_access
    @cardbill = Cardbill.find(params[:id])
    force_redirect unless @cardbill.access?(current_user)
  end

  # GET /cardbills
  # GET /cardbills.xml
  def index
    @cardbills = Cardbill.access_list(current_user).search(params[:q]).searchbycreditcard(params[:creditcard_id]).paginate(:order => 'transdate desc', :page => params[:page], :per_page => 20)
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
  end

  # POST /cardbills
  # POST /cardbills.xml
  def create
    @cardbill = Cardbill.new(params[:cardbill])
    @creditcards = Creditcard.all

    respond_to do |format|
      if @cardbill.save
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
