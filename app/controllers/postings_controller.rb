class PostingsController < ApplicationController
  expose(:posting)

  def index
    @postings = Posting.all
  end

  def new
    unless params[:report].blank?
      @posting = ExpenseReport.find(params[:report]).make_posting
    else
      @posting = Posting.new
    end
  end

  def create
    posting.save!
    redirect_to posting
  rescue ActiveRecord::RecordInvalid
    @posting = posting
    render 'new'
  end
end