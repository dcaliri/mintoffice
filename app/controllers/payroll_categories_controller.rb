class PayrollCategoriesController < ApplicationController
  expose(:payroll_category)
  
  def index
    
  end
  
  def new
    
  end
  
  def create
    payroll_category.save!
    redirect_to [:payroll_category]
  end
  
  def update
    payroll_category.save!
    redirect_to [:payroll_category]
  end
  
end