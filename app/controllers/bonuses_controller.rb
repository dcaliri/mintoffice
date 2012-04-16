class BonusesController < ApplicationController
  expose(:user)
  expose(:bonuses) { user.bonuses }
  expose(:bonus)

  def create
    bonus.save!
    redirect_to payment_path(user)
  end

  def update
    bonus.save!
    redirect_to payment_path(user)
  end

  def destroy
    bonus.destroy
    redirect_to payment_path(user)
  end
end