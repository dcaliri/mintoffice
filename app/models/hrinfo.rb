class Hrinfo < ActiveRecord::Base
  belongs_to :user
  has_one :contact, :as => :target

#  has_many :hrinfo_histories, :class_name => "HrinfoHistory", :foreign_key => "hrinfo_id"
  include Historiable
  include Attachmentable

  validates_format_of :juminno, :with => /^\d{6}-\d{7}$/, :message => I18n.t('hrinfos.error.juminno_invalid')
  validates_uniqueness_of :juminno
  validates_numericality_of :companyno
  validates_uniqueness_of :companyno

  def fullname
    if lastname == nil || firstname == nil
      "unknown"
    else
      lastname + " " + firstname
    end
  end

  def email
    email = read_attribute(:email)
    if email.blank?
      (!contact or contact.emails.empty?) ? "" : contact.emails.first.email
    else
      email
    end
  end

  def mphone
    number = read_attribute(:mphone)
    if number.blank?
      (!contact or contact.phone_numbers.empty?) ? "" : contact.phone_numbers.first.number
    else
      number
    end
  end

  def address
    address = read_attribute(:address)
    if address.blank?
      (!contact or contact.addresses.empty?) ? "" : contact.addresses.first.info
    else
      address
    end
  end

  def self.not_retired
    where("retired_on IS NULL")
  end

  def self.search(text)
    text = "%#{text || ""}%"
    joins(:user).where('users.name LIKE ? OR users.notify_email LIKE ? OR hrinfos.firstname like ? OR hrinfos.lastname LIKE ? OR hrinfos.position LIKE ?', text, text, text, text, text)
  end
end
