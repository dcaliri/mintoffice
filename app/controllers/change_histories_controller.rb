class ChangeHistoriesController < ApplicationController
  expose(:change_history)

  def index
    @histories = ChangeHistory.page(params[:page]).order('created_at DESC')
  end

  def update
    change_history.save!
    redirect_to change_history
  end

  def destroy
    change_history.destroy
    redirect_to :change_histories
  end
end