require 'RMagick'

class AttachmentsController < ApplicationController
  # GET /attachments
  # GET /attachments.xml
  protect_from_forgery :except => [:save]
  def index
    @attachments = Attachment.paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @attachments }
    end
  end

  # GET /attachments/1
  # GET /attachments/1.xml
  def show
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @attachment }
    end
  end
  
  def download
    @attachment = Attachment.find(params[:id])
    unless session[:attachments] && (session[:attachments].include? (@attachment.id))
      flash[:notice] = I18n.t("permissions.permission_denied")
      redirect_to root_path
      return
    end

    path = "#{Rails.root}/files/#{@attachment.filepath}"
    
    send_file path, :filename => (@attachment.original_filename.blank? ? @attachment.filepath : @attachment.original_filename),
                    :type => @attachment.contenttype, 
                    :disposition => 'attachment'
  end
  def picture
    @attachment = Attachment.find(params[:id])
    unless session[:attachments] && (session[:attachments].include? (@attachment.id))
      flash[:notice] = I18n.t("permissions.permission_denied")
      redirect_to root_path
      return
    end
    if params[:w] && params[:h]
      width = params[:w].to_i
      height = params[:h].to_i
    
      dir = "#{Rails.root}/files/#{width}x#{height}"
      path = "#{dir}/#{@attachment.id}"
      if ( ! File.exists?(path) )
        if ( ! File.exist?(dir) )
          Dir.mkdir(dir)
        end
        img = Magick::Image::read("#{Rails.root}/files/#{@attachment.filepath}").first
        thumb = img.resize_to_fit(width,height)
        thumb.write("png:"+path) { self.quality = 90 }
      end
    else
      path = "#{Rails.root}/files/#{@attachment.filepath}"
    end
    send_file path, :filename => @attachment.filepath,
                                    :type => "image/png",
                                    # :disposition => (@attachment.contenttype =~ /^image/ ? 'inline' : 'attachment')
                                    :disposition => 'inline'
  end

  # GET /attachments/new
  # GET /attachments/new.xml
  def new
    @attachment = Attachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @attachment }
    end
  end
  
  def save
    @attachment = Attachment.new(params[:attachment])
    if session[:user_id] 
      @attachment.user = User.find(session[:user_id])
    else
      @attachment.user = User.find(1)
    end
    if @attachment.save
      redirect_to(:action => 'index')
    else
      redirect_to(:action => 'index')
    end
  end

  # GET /attachments/1/edit
  def edit
    @attachment = Attachment.find(params[:id])
  end

  # POST /attachments
  # POST /attachments.xml
  def create
    @attachment = Attachment.new(params[:attachment])

    respond_to do |format|
      if @attachment.save
        flash[:notice] = I18n.t("common.messages.created", :model => Attachment.model_name.human )
        format.html { redirect_to(@attachment) }
        format.xml  { render :xml => @attachment, :status => :created, :location => @attachment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.xml
  def update
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        flash[:notice] = t("attachments.msg.update")
        format.html { redirect_to(@attachment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.xml
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy

    respond_to do |format|
      format.html { redirect_to(attachments_url) }
      format.xml  { head :ok }
    end
  end

  def delete
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    redirect_to :back
  end

  def changeseq
    @attachment = Attachment.find(params[:id])
    tmp = 0
    unless params[:to].to_i == 0
      @a2 = Attachment.find(params[:to].to_i)
      logger.info "attachment 1 = #{@attachment.seq}, 2 = #{@a2.seq}"
      tmp = @a2.seq
      @a2.seq = @attachment.seq
      @attachment.seq = tmp

      @a2.save
      @attachment.save
    end

    redirect_to :back

  end
end
