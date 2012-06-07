class RequiredTagsController < ApplicationController
  def index
    @required_tags = RequiredTag.all(:order => :modelname)
    @modelnames = @required_tags.collect(&:modelname).uniq
  end

  def new
    @required_tag = RequiredTag.new(:modelname => params[:modelname])
    @returnurl = params[:returnurl]
  end

  def create
    @required_tag = RequiredTag.new(params[:required_tag])
    @tag = current_company.tags.find_or_create_by_name(params[:tag][:name])
    @required_tag.tag = @tag

    if @required_tag.save
      flash[:notice] = 'Required Tag was successfully created.'
      if !params[:returnurl].blank?
        redirect_to params[:returnurl]
      else
        redirect_to :action => "index"
      end
    else
      render :action => "new"
    end

  end

  def edit
  end

  def update
  end

  def destroy
    @rt = RequiredTag.find(params[:id])
    @rt.destroy

    redirect_to :action => "index"
  end

  def show

  end

end
