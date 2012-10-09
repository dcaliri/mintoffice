class BankbooksController < ApplicationController
  before_filter :only => [:show] do |c| 
    @bankbook = Bankbook.find(params[:id])
    c.save_attachment_id @bankbook
  end

  def index
    @bankbook = Bankbook.scoped
  end

  def show
    @bankbook = Bankbook.find(params[:id])
  end

  def new
    @bankbook = Bankbook.new
  end

  def create
    @bankbook = Bankbook.new(params[:bankbook])
    @bankbook.save!
    redirect_to @bankbook
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @bankbook = Bankbook.find(params[:id])
  end

  def update
    @bankbook = Bankbook.find(params[:id])
    @bankbook.update_attributes!(params[:bankbook])
    redirect_to @bankbook
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @bankbook = Bankbook.find(params[:id])
    @bankbook.destroy
    redirect_to :bankbooks
  end
end