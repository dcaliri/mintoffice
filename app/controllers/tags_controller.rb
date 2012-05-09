class TagsController < ApplicationController
  before_filter :find_owner, :only => :create

  def create
    @tag = Tag.find_or_create(params[:tag])
    unless @owner.tags.include?(@tag)
      @owner.tags << @tag
    else
      flash[:notice] = 'Already exists'
    end
    redirect_to :back
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy
    redirect_to :back
  end

  private
  def find_owner
    @owner = params[:owner_type].constantize.find(params[:owner_id])
  end
end