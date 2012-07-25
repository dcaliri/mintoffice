class DocumentsController < ApplicationController
  expose(:documents) { current_company.documents }
  expose(:document)

  expose(:projects) { current_company.projects }

  before_filter :only => [:show] {|c| c.save_attachment_id document}
  before_filter :access_check, except: [:index, :new, :create]

  def index
    @documents = documents.filter_by_params(params.merge(account: current_account)).latest.page(params[:page])
  end

  def create
    document.employees << current_account.employee
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

  def destroy
    document.destroy
    redirect_to :documents
  end

  def add_owner
    owner = Account.find_by_name(params[:accountname])
    if owner
      if document.employees.exists?(owner.employee)
        flash[:notice] = 'Already exists'
      else
        document.employees << owner.employee
      end
    else
      flash[:notice] = 'No such account'
    end

    redirect_to [:edit, document]
  end

  def remove_owner
    owner = Employee.find(params[:uid])
    document.employees.delete(owner)
    redirect_to [:edit, document]
  end

  private

  def project_list
    @projects ||= projects.find(:all, :order => "name ASC")
  end

  helper_method :project_list
end
