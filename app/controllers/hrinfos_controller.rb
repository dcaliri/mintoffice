class HrinfosController < ApplicationController
  # GET /hrinfos
  # GET /hrinfos.xml
  def index
    retired = params[:retired]
    if retired == "on"
      @hrinfos = Hrinfo.search(params[:q]).find(:all, :conditions => "retired_on IS NOT NULL")
      @hrinfos_count = Hrinfo.count(:all, :conditions => "retired_on IS NOT NULL")
    else
      @hrinfos = Hrinfo.search(params[:q]).find(:all, :conditions => "retired_on IS NULL")
      @hrinfos_count = Hrinfo.count(:all, :conditions => "retired_on IS NULL")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hrinfos }
    end
  end

  def edit_required_tag

  end

  def retire
    @hrinfo = Hrinfo.find(params[:id])
  end

  def retire_save
    @hrinfo = Hrinfo.find(params[:id])

    if @hrinfo.save
      flash[:notice] = 'retired.'
      format.html { redirect_to(@hrinfo) }
    else
      format.html { render :action => "retire" }
    end
  end

  # GET /hrinfos/1
  # GET /hrinfos/1.xml
  def show
    @hrinfo = Hrinfo.find(params[:id])
    @attachments = Attachment.for_me(@hrinfo, "seq ASC")
    at = params[:at] || "0"
   unless @attachments.empty?
      if session[:attachments].nil?
        session[:attachments] = [@attachments[at.to_i].id]
      else
        session[:attachments] << @attachments[at.to_i].id
      end
   end
    @related_documents = Tag.related_documents(@hrinfo.user.name, Hrinfo.model_name.human)
    @required_tagnames = RequiredTag.find_all_by_modelname(Hrinfo.name).collect do |rt| rt.tag.name end
    @required_tagnames = @required_tagnames.uniq.sort

    @required_documents = {}
    @unrequired_documents = []
    @related_documents.each do |rd|
      cross = rd.tags.collect(&:name) & @required_tagnames
      if cross.empty?
        @unrequired_documents << rd
      else
        cross.each do |one|
          @required_documents[one] = rd
        end
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hrinfo }
    end
  end

  # GET /hrinfos/new
  # GET /hrinfos/new.xml
  def new
    @hrinfo = Hrinfo.new
    @users = User.nohrinfo

    if @users.blank?
      flash[:notice] = t('hrinfos.new.users_blank')
      redirect_to :action => "index"
    else
      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @hrinfo }
      end
    end
  end

  # GET /hrinfos/1/edit
  def edit
    @hrinfo = Hrinfo.find(params[:id])
    @attachments = Attachment.for_me(@hrinfo, "seq ASC")
  end

  # POST /hrinfos
  # POST /hrinfos.xml
  def create
    @hrinfo = Hrinfo.new(params[:hrinfo])
    @users = User.nohrinfo

    respond_to do |format|
      if @hrinfo.save
        @attachment = Attachment.new(params[:attachment])
        @attachment.save_for(@hrinfo,@user)
        flash[:notice] = I18n.t("common.messages.created", :model => Hrinfo.model_name.human)
        format.html { redirect_to(@hrinfo) }
        format.xml  { render :xml => @hrinfo, :status => :created, :location => @hrinfo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hrinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hrinfos/1
  # PUT /hrinfos/1.xml
  def update
    @hrinfo = Hrinfo.find(params[:id])
    respond_to do |format|
      @hrinfo.attributes = params[:hrinfo]
      if @hrinfo.valid?
        @hrinfo.save

        seq = Attachment.maximum_seq_for_me(@hrinfo) || 0
        @attachment = Attachment.new(params[:attachment])
        @attachment.seq = seq+1
        @attachment.save_for(@hrinfo,@user)
        flash[:notice] = I18n.t("common.messages.updated", :model => Hrinfo.model_name.human)
        format.html { redirect_to(@hrinfo) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hrinfo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hrinfos/1
  # DELETE /hrinfos/1.xml
  def destroy
    @hrinfo = Hrinfo.find(params[:id])
    @hrinfo.destroy

    respond_to do |format|
      format.html { redirect_to(hrinfos_url) }
      format.xml  { head :ok }
    end
  end
end
