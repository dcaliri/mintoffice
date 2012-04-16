class BonusesController < ApplicationController
  before_filter :check_payment_permission, :check_admin

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