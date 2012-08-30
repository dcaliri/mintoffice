class Dayworker < ActiveRecord::Base
  belongs_to :person
  has_one :bankbook, as: :holder

  include Attachmentable

  before_create :create_person_if_not

  attr_accessor :bankbook_id
  before_save :save_bankook
private
  def save_bankook
    unless bankbook_id.blank?
      self.bankbook = Bankbook.find(bankbook_id)
    else
      self.bankbook = nil
    end
  end

  def create_person_if_not
    self.create_person unless self.person
  end
end