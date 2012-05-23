class DocumentsController < ApplicationController
  expose(:documents) { current_company.documents }
  expose(:document)

  expose(:projects) { current_company.projects }

  before_filter :only => [:show] {|c| c.save_attachment_id document}
  before_filter :check_report_access, except: [:index, :new, :create]

  def index
    @documents = documents.access_list(current_user)
                          .report_status(params[:report_status])
                          .search(params[:query])
                          .latest
                          .page(params[:page])
  end

  def create
    document.users << current_user
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
    owner = User.find_by_name(params[:username])
    if owner
      if document.users.exists?(owner)
        flash[:notice] = 'Already exists'
      else
        document.users << owner
      end
    else
      flash[:notice] = 'No such user'
    end

    redirect_to [:edit, document]
  end

  def remove_owner
    owner = User.find(params[:uid])
    document.users.delete(owner)
    redirect_to [:edit, document]
  end

  private

  def project_list
    @projects ||= projects.find(:all, :order => "name ASC")
  end

  helper_method :project_list
end
