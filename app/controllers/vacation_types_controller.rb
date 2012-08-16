class VacationTypesController < ApplicationController
  def index
    @types = VacationType.all
  end

  def show
    @vacation_type = VacationType.find(params[:id])
  end

  def new
    @vacation_type = VacationType.new
  end

  def create
    @vacation_type = VacationType.new(params[:vacation_type])
    @vacation_type.save!
    redirect_to @vacation_type, notice: I18n.t("common.messages.created", :model => VacationType.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def edit
    @vacation_type = VacationType.find(params[:id])
  end

  def update
    @end = VacationType.find(params[:id])
    @end.update_attributes!(params[:vacation_type])
    redirect_to @end, notice: I18n.t("common.messages.updated", :model => VacationType.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @vacation_type = VacationType.find(params[:id])
    @vacation_type.destroy
    redirect_to :vacation_types
  end
end