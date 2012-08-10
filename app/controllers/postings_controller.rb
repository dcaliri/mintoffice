class PostingsController < ApplicationController
  expose(:posting)

  def index
    @postings = Posting.all
  end

  def new
    unless params[:report].blank?
      @expense_report = ExpenseReport.find(params[:report])
      @posting = @expense_report.make_posting
    else
      @posting = Posting.new
    end
  end

  def edit
    @posting = Posting.find(params[:id])
  end

  def create
    @posting = Posting.new(params[:posting])
    @posting.save!
    redirect_to @posting
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    @posting = Posting.find(params[:id])
    @posting.update_attributes!(params[:posting])
    redirect_to @posting
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    posting.destroy
    redirect_to :postings
  end
end