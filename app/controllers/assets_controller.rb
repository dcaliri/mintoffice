class AssetsController < ApplicationController
  def index
    @assets = Asset.scoped
  end

  def show
    @asset = Asset.find(params[:id])
  end

  def new
    @asset = Asset.new
  end

  def create
    @asset = Asset.new(params[:asset])
    @asset.save!
    redirect_to @asset
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @asset = Asset.find(params[:id])
  end

  def update
    @asset = Asset.find(params[:id])
    @asset.update_attributes!(params[:asset])
    redirect_to @asset
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    redirect_to :assets
  end
end