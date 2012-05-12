class NamecardsController < ApplicationController
  before_filter :only => [:show] do |c|
    @namecard = Namecard.find(params[:id])
    c.save_attachment_id @namecard
  end

  def index
#    @namecards = Namecard.order('id desc').paginate(:page => params[:page], :per_page => 20)
    @namecards = Namecard.search(params[:q]).order('id desc').paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @namecard = Namecard.new
  end

  def create
    @namecard = Namecard.new(params[:namecard])

    respond_to do |format|
      if @namecard.save
        flash[:notice] = t('common.messages.created', :model => Namecard.model_name.human)
        format.html { redirect_to(@namecard) }
        format.xml  { render :xml => @namecard, :status => :created, :location => @namecard }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @namecard.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @namecard = Namecard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @namecard }
    end
  end

  def edit
    @namecard = Namecard.find(params[:id])
  end

  def update
    @namecard = Namecard.find(params[:id])

    respond_to do |format|
      if @namecard.update_attributes(params[:namecard])
        flash[:notice] = t('common.messages.updated', :model => Namecard.model_name.human)
        format.html { redirect_to(@namecard) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @namecard.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
  end

end
