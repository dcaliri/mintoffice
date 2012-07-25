class DayworkerTaxesController < ApplicationController
  # before_filter :redirect_unless_admin, :only => :index
  # 
  # expose(:accounts) { Account(:protected) }
  # expose(:account)
  # expose(:vacations) { account.vacations.latest }
  # expose(:vacation)
  # 
  # before_filter {|controller| controller.redirect_unless_me(account)}
  # 
  # def index
  #   @accounts = Account(:protected).enabled.page(params[:page])
  # end
  # 
  # def create
  #   vacation.save!
  #   redirect_to [account, vacation]
  # end
  # 
  # def update
  #   vacation.save!
  #   redirect_to [account, vacation]
  # end
  # 
  # def destroy
  #   vacation.destroy
  #   redirect_to [account, vacation]
  # end

  expose (:dayworker_taxes) { DayworkerTax.all }
  expose (:dayworker_tax)
  # 
  def create
    dayworker_tax.save!
    redirect_to dayworker_tax
  end
  
  def update
    dayworker_tax.save!
    redirect_to dayworker_tax
    end
end