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

  def company
    Company.first
  end

  def work_from
    joined_on
  end

  def work_to
    retired_on || Time.zone.now
  end

  def generate_employment_proof(purpose)
    filename = "#{Rails.root}/tmp/#{fullname}_employment_proof.pdf"
    template = "#{Rails.root}/app/assets/images/employment_proof_tempate.pdf"

    Prawn::Document.generate(filename, template: template) do |pdf|
      pdf.font "#{Rails.root}/public/fonts/NanumGothic.ttf"
      pdf.font_size 12

      pdf.draw_text fullname, :at => [142, 685]
      pdf.draw_text juminno, :at => [142, 661]
      pdf.draw_text address, :at => [142, 637]
      pdf.draw_text department, :at => [142, 526]
      pdf.draw_text position, :at => [333, 526]

      pdf.draw_text company.name, :at => [142, 613]
      pdf.draw_text company.registration_number, :at => [333, 613]
      pdf.draw_text company.owner_name, :at => [142, 589]
      pdf.draw_text company.address, :at => [142, 558]
      pdf.draw_text company.phone_number, :at => [333, 589]

      pdf.draw_text work_from.year, :at => [168, 494]
      pdf.draw_text work_from.month, :at => [220, 494]
      pdf.draw_text work_from.day, :at => [252, 494]

      pdf.draw_text work_to.year, :at => [318, 494]
      pdf.draw_text work_to.month, :at => [370, 494]
      pdf.draw_text work_to.day, :at => [402, 494]

      # pdf.draw_text company.hrinfos.count, :at => [402, 494]
      pdf.draw_text Hrinfo.count, :at => [142, 460]
      pdf.draw_text purpose, :at => [333, 460]

      pdf.draw_text "대표", :at => [175, 433]
      pdf.draw_text company.owner_name, :at => [385, 433]

      today = Time.zone.now
      pdf.draw_text today.year, :at => [198, 311]
      pdf.draw_text today.month, :at => [262, 311]
      pdf.draw_text today.day, :at => [306, 311]

      pdf.draw_text company.name, :at => [250, 255]
      pdf.draw_text company.owner_name, :at => [250, 225]
    end

    filename
  end

  def self.search(text)
    text = "%#{text}%"
    joins(:user).where('users.name LIKE ? OR users.notify_email LIKE ? OR hrinfos.firstname like ? OR hrinfos.lastname LIKE ? OR hrinfos.position LIKE ?', text, text, text, text, text)
  end
end
