class Dayworker < ActiveRecord::Base
  belongs_to :person
  
  include Attachmentable
  belongs_to :bankbook

  before_create :create_person_if_not

  def name
    person.contact.name rescue ""
  end

private
  def create_person_if_not
    self.create_person unless self.person
  end
end