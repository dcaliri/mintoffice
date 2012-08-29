class DocumentsController < ApplicationController
  expose(:documents) { current_company.documents }
  expose(:document)

  expose(:projects) { current_company.projects }

  before_filter :only => [:show] {|c| c.save_attachment_id document}
  before_filter :access_check, except: [:index, :new, :create]

  def index
    @documents = documents.search(params.merge(person: current_person)).latest.page(params[:page])
  end

  def create
    document.add_tags(params[:tag])
    document.save!
    redirect_to document, notice: t('common.messages.created', :model => Document.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render :action => "new"
  end

  def update
    document.save!
    redirect_to document, notice: t('common.messages.updated', :model => Document.model_name.human)
  rescue ActiveRecord::RecordInvalid
    render :action => "edit"
  end

  def find_employee
    @document = Document.find(params[:id])
    @employees = Employee.not_retired
  end

  def link_employee
    @document = Document.find(params[:id])
    @employee = Employee.find(params[:employee])

    @document.employee = @employee
    @document.save!

    redirect_to @document
  end

  def destroy
    document.destroy
    redirect_to :documents
  end

private
  def project_list
    @projects ||= current_employee.projects.inprogress.find(:all, :order => "name ASC")
  end
  helper_method :project_list
end
