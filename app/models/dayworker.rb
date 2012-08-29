class Dayworker < ActiveRecord::Base
  has_one :payment_request, as: :basis

  belongs_to :person
  has_one :bankbook, as: :holder

  include Attachmentable

  before_create :create_person_if_not

  attr_accessor :bankbook_id
  before_save :save_bankook
private
  def save_bankook
    self.bankbook = Bankbook.find(bankbook_id) unless bankbook_id.blank?
  end

  def create_person_if_not
    self.create_person unless self.person
  end
end