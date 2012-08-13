class DayworkersController < ApplicationController
  expose (:dayworkers) { Dayworker.all }
  expose (:dayworker)

  def find_contact
    @contacts = Contact.search(params[:query])
  end

  def select_contact
    dayworker.contact = Contact.find(params[:contact])
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

end