class NamecardsController < ApplicationController
  before_filter :only => [:show] do |c|
    @namecard = Namecard.find(params[:id])
    c.save_attachment_id @namecard
  end

  def index
    @namecards = Namecard.search(params[:q]).order('id desc').paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @namecard = Namecard.new
  end

  def create
    @namecard = Namecard.new(params[:namecard])
    @namecard.save!
    redirect_to @namecard
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def show
    @namecard = Namecard.find(params[:id])
  end

  def edit
    @namecard = Namecard.find(params[:id])
  end

  def update
    @namecard = Namecard.find(params[:id])
    @namecard.update_attributes!(params[:namecard])
    redirect_to @namecard
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end
end
