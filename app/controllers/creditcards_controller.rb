class CreditcardsController < ApplicationController
  before_filter :only => [:show] do |c|
    @creditcard = Creditcard.find(params[:id])
    c.save_attachment_id @creditcard
  end

  # GET /creditcards
  # GET /creditcards.xml
  def preview
    @collection = Creditcard.preview_stylesheet(params[:card_type], params[:upload])
  rescue => error
    redirect_to [:excel, :creditcards], alert: error.message
  end

  def upload
    Creditcard.create_with_stylesheet(params[:card_type], params[:upload])
    redirect_to :creditcards
  end

  def index
    @creditcards = Creditcard.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @creditcards }
    end
  end

  # GET /creditcards/1
  # GET /creditcards/1.xml
  def show
    @creditcard = Creditcard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @creditcard }
    end
  end

  # GET /creditcards/new
  # GET /creditcards/new.xml
  def new
    @creditcard = Creditcard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @creditcard }
    end
  end

  # GET /creditcards/1/edit
  def edit
    @creditcard = Creditcard.find(params[:id])
  end

  # POST /creditcards
  # POST /creditcards.xml
  def create
    @creditcard = Creditcard.new(params[:creditcard])

    respond_to do |format|
      if @creditcard.save
        flash[:notice] = 'Creditcard was successfully created.'
        format.html { redirect_to(@creditcard) }
        format.xml  { render :xml => @creditcard, :status => :created, :location => @creditcard }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @creditcard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /creditcards/1
  # PUT /creditcards/1.xml
  def update
    @creditcard = Creditcard.find(params[:id])
    respond_to do |format|
      @creditcard.attributes = params[:creditcard]
      if @creditcard.valid?
        @creditcard.save!
        flash[:notice] = t("common.messages.updated", :model => Creditcard.model_name.human)
        format.html { redirect_to(@creditcard) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @creditcard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /creditcards/1
  # DELETE /creditcards/1.xml
  def destroy
    @creditcard = Creditcard.find(params[:id])
    @creditcard.destroy

    respond_to do |format|
      format.html { redirect_to(creditcards_url) }
      format.xml  { head :ok }
    end
  end
end
