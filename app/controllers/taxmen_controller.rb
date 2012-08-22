# encoding: UTF-8

class TaxmenController < ApplicationController
  before_filter :find_business_client
  before_filter :check_contact_exist, only: [:select_contact, :update_contact]

  def check_contact_exist
    @contact = Contact.find(params[:contact])
    unless @business_client.taxmen.person_exist?(@contact.person)
      redirect_to @business_client, notice: "이미 존재합니다"
    end
  end

  def find_contact
    @contacts = Contact.search(params[:query])
  end

  def select_contact
    @taxman = @business_client.taxmen.build
    @contact = Contact.find(params[:contact])

    if @contact.person
      @taxman.person = @contact.person
    else
      @taxman.build_person
      @taxman.person.contact = @contact
    end

    @taxman.save!
    redirect_to @business_client
  rescue ActiveRecord::RecordInvalid
    @contacts = Contact.search(params[:query])
    render 'find_contact'
  end

  def edit_contact
    @taxman = @business_client.taxmen.find(params[:id])
    @contacts = Contact.search(params[:query])
  end

  def update_contact
    @taxman = @business_client.taxmen.find(params[:id])

    if @contact.person
      @taxman.person = Contact.find(params[:contact]).person
    else
      @taxman.build_person
      @taxman.person.contact = Contact.find(params[:contact])
    end

    @taxman.person.save!
    @taxman.save!
    redirect_to @business_client
  rescue ActiveRecord::RecordInvalid
    @contacts = Contact.search(params[:query])
    render 'edit_contact'
  end

  def create
    @taxman = @business_client.taxmen.build(params[:taxman])
    @taxman.save!
    redirect_to @business_client
  rescue ActiveRecord::RecordInvalid
    render 'new'
  end

  def update
    @taxman = @business_client.taxmen.find(params[:id])
    @taxman.update_attributes(params[:taxman])
    redirect_to @business_client
  rescue ActiveRecord::RecordInvalid
    render 'edit'
  end

  def destroy
    @taxman = @business_client.taxmen.find(params[:id])
    @taxman.destroy
    redirect_to @business_client
  end

  private
  def find_business_client
    @business_client = BusinessClient.find(params[:business_client_id])
  end
end