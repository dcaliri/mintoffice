class DayworkersController < ApplicationController
  expose (:dayworkers) { Dayworker.all }
  expose (:dayworker)

  before_filter :only => [:show] {|c| c.save_attachment_id dayworker}

  def find_contact
    @contacts = Contact.search(params[:query])
  end

  def select_contact
    dayworker.person.contact = Contact.find(params[:contact])
    dayworker.save!
    redirect_to dayworker
  end

  def create
    dayworker.save!
    redirect_to dayworker
  end

  def update
    dayworker.save!
    redirect_to dayworker
  end

  def payment_request
    @payment_request = dayworker.generate_payment_request
    render 'payment_requests/new'
  end
end