class Dayworker < ActiveRecord::Base
  belongs_to :person

  include Attachmentable

  before_create :create_person_if_not

private
  def create_person_if_not
    self.create_person unless self.person
  end
end