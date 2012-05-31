# encoding: UTF-8

class Hrinfo < ActiveRecord::Base
  belongs_to :user
  has_one :contact, :as => :target, dependent: :destroy
  accepts_nested_attributes_for :contact, :allow_destroy => :true

  has_many :report, :as => :target
  has_many :expense_reports

  include Historiable
  include Attachmentable

  validates_format_of :juminno, :with => /^\d{6}-\d{7}$/, :message => I18n.t('hrinfos.error.juminno_invalid')
  validates_uniqueness_of :juminno
  validates_numericality_of :companyno
  validates_uniqueness_of :companyno

  attr_accessor :email, :phone_number, :address

  def contact_or_build
    self.contact || build_contact
  end

  def firstname=(value)
    super
    contact_or_build.firstname = value
  end

  def lastname=(value)
    super
    contact_or_build.lastname = value
  end

  def position=(value)
    super
    contact_or_build.position = value
  end

  def email=(email)
    contact = contact_or_build
    contact_email = contact.emails.empty? ? contact.emails.build : contact.emails.first
    contact_email.email = email
    contact_email.save!
  end

  def phone_number=(number)
    contact = contact_or_build
    contact_phone_number = contact.phone_numbers.empty? ? contact.phone_numbers.build : contact.phone_numbers.first
    contact_phone_number.number = number
    contact_phone_number.save!
  end

  def address=(address_info)
    contact = contact_or_build
    contact_address = contact.addresses.empty? ? contact.addresses.build : contact.addresses.first
    contact_address.other1 = address_info
    contact_address.save!
  end

  def fullname
    if lastname == nil || firstname == nil
      "unknown"
    else
      lastname + " " + firstname
    end
  end

  def email
    contact.emails.first.email rescue ""
  end

  def phone_number
    contact.phone_numbers.first.number rescue " "
  end

  def address
    contact.addresses.first.info rescue ""
  end

  def self.payment_in?(from, to)
    select{|hrinfo| hrinfo.user.payments.payment_in?(from, to).total > 0 }
  end

  def self.not_retired
    where("retired_on IS NULL")
  end

  def retire!
    user.payments.retire!(retired_on)
    save!
  end

  def generate_employment_proof
    filename = "#{Rails.root}/tmp/#{fullname}_employment_proof.pdf"
    template = "#{Rails.root}/app/assets/images/employment_proof_tempate.pdf"

    Prawn::Document.generate(filename, template: template) do |pdf|
      pdf.font "#{Rails.root}/public/fonts/NanumGothic.ttf"
      pdf.font_size 12
      pdf.text "이름 = #{fullname}", align: :center
      pdf.text "주민등록번호 = #{juminno}", align: :center
      pdf.text "주소 = #{address}", align: :center
    end

    filename
  end

  def self.search(text)
    text = "%#{text}%"
    joins(:user).where('users.name LIKE ? OR users.notify_email LIKE ? OR hrinfos.firstname like ? OR hrinfos.lastname LIKE ? OR hrinfos.position LIKE ?', text, text, text, text, text)
  end
end
