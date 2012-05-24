class PostingsController < ApplicationController
  expose(:posting)

  def index
    @postings = Posting.all
  end

  def new
    @posting = ExpenseReport.find(params[:report]).make_posting unless params[:report].blank?
  end

  def create
    posting.save!
    redirect_to posting
  end

  def edit
    @posting = posting
  end

  def update
    posting.save!
    redirect_to posting
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    posting.destroy
    redirect_to :postings
  end
end