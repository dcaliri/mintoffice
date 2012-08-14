class CardbillsController < ApplicationController
  before_filter :only => [:show] do |c|
    @cardbill = Cardbill.find(params[:id])
    c.save_attachment_id @cardbill
  end

  before_filter :access_check, except: [:index, :new, :create]
  before_filter :find_creditcards

  def index
    arguments = params.merge(person: current_person)
    @cardbills = Cardbill.search(arguments).page(params[:page])
  end

  def show
    @cardbill = Cardbill.find(params[:id])
  end

  def new
    @cardbill = Cardbill.new
  end

  def edit
    @cardbill = Cardbill.find(params[:id])
  end

  def create
    @cardbill = Cardbill.new(params[:cardbill])
    @cardbill.save!
    redirect_to @cardbill, notice: I18n.t("common.messages.created", :model => Cardbill.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    @cardbill = Cardbill.find(params[:id])
    @cardbill.update_attributes!(params[:cardbill])
    redirect_to @cardbill, notice: I18n.t("common.messages.updated", :model => Cardbill.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @cardbill = Cardbill.find(params[:id])
    @cardbill.destroy
    redirect_to :cardbills
  end

  private
  def find_creditcards
    @creditcards = Creditcard.all
  end
end
