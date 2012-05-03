class CardApprovedSource < ActiveRecord::Base
  belongs_to :creditcard

  self.per_page = 20

  before_save :strip_approve_no
  def strip_approve_no
    approve_no.strip!
  end

  def cardbill
    collection = Cardbill.where(approveno: approve_no)
    collection.first unless collection.empty?
  end

  def used_at_to_s
    attribute = read_attribute(:used_at)
    attribute.blank? ? "" : attribute.strftime("%Y.%m.%d %H:%M")
  end

  def canceled_at_to_s
    attribute = read_attribute(:canceled_at)
    attribute.blank? ? "" : attribute.strftime("%Y %m.%d")
  end


  def will_be_paied_at_to_s
    attribute = read_attribute(:will_be_paied_at)
    attribute.blank? ? "" : attribute.strftime("%Y %m.%d")
  end

  def self.latest
    order("used_at DESC")
  end
end