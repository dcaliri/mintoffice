class AssetsController < ApplicationController
  before_filter :redirect_unless_owner, except: :index

  def index
    @assets = if current_person.admin?
                Asset.scoped
              else
                current_person.employee.assets
              end
    @assets = @assets.page(params[:page])
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

  def return
    @asset = Asset.find(params[:id])
    @asset.return!
    redirect_to @asset
  end

  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy
    redirect_to :assets
  end

private
  def redirect_unless_owner
    @asset = Asset.find(params[:id])
    force_redirect unless current_person.admin? or @asset.owner == current_person.employee
  end
end