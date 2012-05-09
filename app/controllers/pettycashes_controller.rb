class PettycashesController < ApplicationController
  before_filter :only => [:show] do |c|
    @pettycash = Pettycash.find(params[:id])
    c.save_attachment_id @pettycash
  end

  # GET /pettycashes
  # GET /pettycashes.xml
  def index
    @pettycashes = Pettycash.search(params[:q]).paginate(:order => 'transdate desc', :page => params[:page], :per_page => 20)
    inmoney_total = Pettycash.sum(:inmoney)
    outmoney_total = Pettycash.sum(:outmoney)
    @balance = inmoney_total - outmoney_total
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pettycashes }
    end
  end

  # GET /pettycashes/1
  # GET /pettycashes/1.xml
  def show
    @pettycash = Pettycash.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pettycash }
    end
  end

  # GET /pettycashes/new
  # GET /pettycashes/new.xml
  def new
    @pettycash = Pettycash.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pettycash }
    end
  end

  # GET /pettycashes/1/edit
  def edit
    @pettycash = Pettycash.find(params[:id])
  end

  # # POST /pettycashes
  # # POST /pettycashes.xml
  # def create
  #   @pettycash = Pettycash.new(params[:pettycash])
  #
  #   respond_to do |format|
  #     if @pettycash.save
  #       flash[:notice] = 'Pettycash was successfully created.'
  #       format.html { redirect_to(@pettycash) }
  #       format.xml  { render :xml => @pettycash, :status => :created, :location => @pettycash }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @pettycash.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

#  def save
  def create
    @pettycash = Pettycash.new(params[:pettycash])

    respond_to do |format|
      if @pettycash.save
        flash[:notice] = 'Pettycash was successfully created.'
        format.html { redirect_to(@pettycash) }
        format.xml  { render :xml => @pettycash, :status => :created, :location => @pettycash }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pettycash.errors, :status => :unprocessable_entity }
      end
    end
  end
  # PUT /pettycashes/1
  # PUT /pettycashes/1.xml
  def update
    @pettycash = Pettycash.find(params[:id])

    respond_to do |format|
      if @pettycash.update_attributes(params[:pettycash])
        seq = Attachment.maximum_seq_for_me(@pettycash) || 0

        flash[:notice] = I18n.t("common.messages.updated", :model => Pettycash.model_name.human)
        format.html { redirect_to(@pettycash) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pettycash.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pettycashes/1
  # DELETE /pettycashes/1.xml
  def destroy
    @pettycash = Pettycash.find(params[:id])
    @pettycash.destroy

    respond_to do |format|
      format.html { redirect_to(pettycashes_url) }
      format.xml  { head :ok }
    end
  end
end
