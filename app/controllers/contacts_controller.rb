# encoding: UTF-8

class ContactsController < ApplicationController
  expose(:contacts) { current_company.contacts }
  expose(:contacts) { Contact.where("") }
  expose(:contact)

  before_filter :only => [:show] { |c| c.save_attachment_id contact }
  before_filter :redirect_if_private, :only => [:show, :edit, :update, :destroy]
  before_filter :redirect_cannot_edit, :only => [:edit, :update, :destroy]

  def index
    @contacts = contacts.isprivate(current_person).search(params[:query])
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
        # @target = collections.build
        @target = collections.create!
        @target.build_person
      end
    end

    @target.person.contact = @contact
    @target.save!
  end

  def save
    contact = OpenApi::GoogleContact.new(id: params[:id], password: params[:password])
    current_person.contacts.save_to(contact)
    redirect_to :contacts, notice: t('controllers.contacts.success_save')
  rescue ArgumentError => e
    logger.info "failed to save google contact - #{e.message}"
    redirect_to :contacts, alert: t('controllers.contacts.fail_save')
  end

  def load
    contact = OpenApi::GoogleContact.new(id: params[:id], password: params[:password])
    current_person.contacts.load_from(contact)
    redirect_to :contacts, notice: t('controllers.contacts.success_read')
  rescue ArgumentError => e
    logger.info "failed to load google contact - #{e.message}"
    redirect_to :contacts, alert: t('controllers.contacts.fail_read')
  end

  def new
    @contact = contacts.where(owner_id: current_person.id).build
  end

  def edit
    @contact = contacts.find(params[:id])
  end

  def create
    @contact = contacts.where(owner_id: current_person.id).build(params[:contact])
    @contact.save!
    redirect_to redirect_url_if_subject
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    contact.save!
    redirect_to contact
  rescue ActiveRecord::RecordInvalid
    render "edit"
  end

  def destroy
    contact.destroy
    redirect_to contact
  end

  private
  def redirect_if_private
    @contact = contacts.find(params[:id])
    force_redirect unless @contact.access?(current_person)
  end

  def redirect_cannot_edit
    @contact = contacts.find(params[:id])
    force_redirect unless @contact.edit?(current_person)
  end

  def url_options
    super.merge(subject: params[:subject])
  end

  def redirect_url_if_subject
    path = params[:redirect_to_subject]
    path.blank? ? @contact : path
  end
  helper_method :redirect_url_if_subject
end