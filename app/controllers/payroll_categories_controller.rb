class PayrollCategoriesController < ApplicationController
  expose(:payroll_category)
  
  def index
    
  end
  
  def new
    
  end
  
  def create
    if payroll_category.save
      redirect_to [:payroll_categories]
    else
      render "new"
    end
  end
  
  def update
    if payroll_category.save 
      redirect_to [:payroll_category]
    else
      render "edit"
    end
  end
  
  def destroy
    payroll_category.destroy
    redirect_to payroll_categories_path
  end
end