class ContactsController < ApplicationController
  expose(:contacts) { current_company.contacts }
  expose(:contact)

  before_filter :only => [:show] { |c| c.save_attachment_id contact }
  before_filter :redirect_if_private, :only => [:show, :edit, :update]

  def index
    @contacts = contacts.isprivate(@user).search(params[:query])
    @paginated = @contacts.paginate(:page => params[:page], :per_page => 20)
  end

  def find
    @contacts = contacts.search(params[:query])
  end

  def select
    @contact = contacts.find(params[:id])

    target_class = params[:parent_class].blank? ? params[:target_class] : params[:parent_class]
    target_id = params[:parent].blank? ? params[:target] : params[:parent]

    @target = target_class.constantize.find(target_id)

    unless params[:parent_class].blank?
      collections = @target.send(params[:target_class].downcase.pluralize)
      unless params[:target].blank?
        @target = collections.find(params[:target])
      else
        @target = collections.build
      end
    end

    @target.contact = @contact
    @target.save!
  end

  def create
    contact = contacts.where(owner_id: current_user.id).build(params[:contact])
    contact.save!
    redirect_to contact
  end

  def update
    if contact.valid?
      contact.save!
      redirect_to contact
    else
      render :action => "edit"
    end
  end

  def destroy
    contact.destroy
    redirect_to contact
  end

  private
  def redirect_if_private
    @contact = contacts.find(params[:id])
    force_redirect unless @contact.access?(current_user)
  end
end