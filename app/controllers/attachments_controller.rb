# require 'RMagick'

class AttachmentsController < ApplicationController
  protect_from_forgery :except => [:save]

  def index
    @attachments = Attachment.paginate(:page => params[:page], :per_page => 20).order('created_at DESC')
  end

  def show
    @attachment = Attachment.find(params[:id])
    session[:attachments] = [@attachment.id]
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

  def new
    @attachment = Attachment.new
  end

  def save
    @attachment = Attachment.new(params[:attachment])


    if current_employee
      @attachment.employee = current_employee
    else
      @attachment.employee = Employee.find(1)
    end

    if @attachment.save
      redirect_to :attachments, notice: I18n.t("common.messages.created", :model => Attachment.model_name.human)
    else
      render 'new'
    end
  end

  def edit
    @attachment = Attachment.find(params[:id])
  end

  def create
    @attachment = Attachment.new(params[:attachment])
    @attachment.save!
    redirect_to @attachment
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    @attachment = Attachment.find(params[:id])
    @attachment.update_attributes!(params[:attachment])
    redirect_to @attachment
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment.destroy
    redirect_to :attachments
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

      if @attachment.seq.blank?
        @attachment.seq = @attachment.id + 1#@a2.id
      end
      if @a2.seq.blank?
        @a2.seq = @a2.id + 1
      end

      tmp = @a2.seq
      @a2.seq = @attachment.seq
      @attachment.seq = tmp

      @a2.save
      @attachment.save
    end

    redirect_to :back

  end
end
