# encoding: UTF-8

class Hrinfo < ActiveRecord::Base
  # belongs_to :user
  belongs_to :person

  has_and_belongs_to_many :groups
  has_and_belongs_to_many :permission
  
  # has_one :contact, :as => :target, dependent: :destroy

  has_many :payments
  has_many :commutes
  has_many :vacations
  has_many :expense_reports
  has_many :payrolls

  has_many :attachment
  has_many :except_columns
  has_many :change_histories

  has_many :reporters, class_name: 'ReportPerson'
  has_many :accessors, class_name: 'AccessPerson'

  has_many :document_owners, :order => 'created_at DESC'
  has_many :documents, :through => :document_owners, :source => :document
  
  has_many :project_infos, class_name: "ProjectAssignInfo"
  has_many :projects, through: :project_infos
  
  serialize :employment_proof_hash, Array

  include Historiable
  include Attachmentable

  validates_format_of :juminno, :with => /^\d{6}-\d{7}$/, :message => I18n.t('hrinfos.error.juminno_invalid')
  validates_uniqueness_of :juminno

  # validates_presence_of :firstname
  # validates_presence_of :lastname

  attr_accessor :email, :phone_number, :address

  SEARCH_TYPE = {
    I18n.t('models.hrinfo.join') => :join,
    I18n.t('models.hrinfo.retire') => :retire
  }

  class << self
    def not_joined(not_joined)
      if not_joined
        where('joined_on IS NULL')
      else
        where('joined_on IS NOT NULL')
      end
    end
  end

  def user
    person.user
  end
  
  def contact
    person.contact
  end

  def ingroup? (name)
    group = Group.find_by_name(name)
    unless group.nil?
      group.hrinfos.include? self
    else
      false
    end
  end
  
  def admin?
    self.ingroup? "admin"
  end

  def joined?
    joined_on
  end

  def not_joined?
    not joined?
  end

  def retired?
    retired_on?
  end

  def contact_or_build
    self.person.contact || person.build_contact
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
    select{|hrinfo| hrinfo.payments.payment_in?(from, to).total > 0 }
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

  def apply_status
    case report.status
    when :rollback
      I18n.t('models.hrinfo.request')
    else
      I18n.t('models.hrinfo.approve')
    end
  end

  def generate_employment_proof(purpose)
    filename = "#{Rails.root}/tmp/#{fullname}_employment_proof.pdf"
    template = "#{Rails.root}/app/assets/images/employment_proof_tempate.pdf"
    hash_key = Time.now.utc.strftime("%Y%m%d%H%M%S") + id.to_s + Array.new(10).map { (65 + rand(58)).chr }.join
    hash_key = Digest::SHA1.hexdigest(hash_key)

    Prawn::Document.generate(filename, template: template) do |pdf|
      pdf.image company.seal, :at => [320, 255], width: 50, height: 50
      pdf.image company.seal, :at => [415, 463], width: 50, height: 50

      pdf.font "#{Rails.root}/public/fonts/NanumGothic.ttf"
      pdf.font_size 12

      pdf.draw_text fullname, :at => [142, 685]
      pdf.draw_text juminno, :at => [142, 661]
      pdf.draw_text address.strip, :at => [142, 637]
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

      # pdf.draw_text company.hrinfos.not_retired.count, :at => [402, 494]
      pdf.draw_text Hrinfo.not_retired.count, :at => [142, 460]
      pdf.draw_text purpose, :at => [333, 460]

      pdf.draw_text I18n.t('models.hrinfo.representative'), :at => [175, 433]
      pdf.draw_text company.owner_name, :at => [385, 433]

      today = Time.zone.now
      pdf.draw_text today.year, :at => [198, 311]
      pdf.draw_text today.month, :at => [262, 311]
      pdf.draw_text today.day, :at => [306, 311]

      pdf.draw_text company.name, :at => [250, 255]
      pdf.draw_text company.owner_name, :at => [250, 225]

      pdf.draw_text I18n.t('models.hrinfo.code')+"#{hash_key}", :at => [14, 45], :size => 10
    end

    employment_proof_hash << hash_key
    save!

    filename
  end

  class << self
    def search(user, type, text)
      search_by_type(user, type).search_by_text(text)
    end

    def search_by_type(user, type)
      type = type.to_sym
      if user and user.admin? and type == :retire
        where('retired_on IS NOT NULL')
      else
        where('joined_on IS NOT NULL AND retired_on IS NULL')
      end
    end

    def search_by_text(text)
      text = "%#{text}%"
      joins(:person => :user).where('users.name LIKE ? OR users.notify_email LIKE ? OR hrinfos.firstname like ? OR hrinfos.lastname LIKE ? OR hrinfos.position LIKE ?', text, text, text, text, text)
    end
  end
end
