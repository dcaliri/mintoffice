class PostingsController < ApplicationController
  expose(:posting)

  def index
    @postings = Posting.all
  end

  def create
    posting.save!
    redirect_to posting
  end

  def update
    posting.save!
    redirect_to posting
  end

  def destroy
    posting.destroy
    redirect_to :postings
  end
end