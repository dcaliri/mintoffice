# encoding: UTF-8

class Employee < ActiveRecord::Base
  belongs_to :person

  has_many :payments
  has_many :commutes
  has_many :vacations
  has_many :expense_reports
  has_many :payrolls

  has_many :attachment
  has_many :except_columns
  has_many :change_histories

  has_many :document_owners, :order => 'created_at DESC'
  has_many :documents, :through => :document_owners, :source => :document
  
  has_many :project_infos, class_name: "ProjectAssignInfo"
  has_many :projects, through: :project_infos
  
  serialize :employment_proof_hash, Array

  include Historiable
  include Attachmentable
  include EmploymentProof

  validates_format_of :juminno, :with => /^\d{6}-\d{7}$/, :message => I18n.t('employees.error.juminno_invalid')
  validates_uniqueness_of :juminno

  attr_accessor :email, :phone_number, :address

  SEARCH_TYPE = {
    I18n.t('models.employee.join') => :join,
    I18n.t('models.employee.retire') => :retire
  }

  class << self
    def find_by_account_name(account_name)
      joins(:person => :account).merge(Account.where(name: account_name))
    end

    def search(account, type, text)
      search_by_type(account, type).search_by_text(text)
    end

    def search_by_type(account, type)
      type = type.to_sym
      if account and account.admin? and type == :retire
        where('retired_on IS NOT NULL')
      else
        where('joined_on IS NOT NULL AND retired_on IS NULL')
      end
    end

    def search_by_text(text)
      text = "%#{text}%"
      joins(:person => :account).where('accounts.name LIKE ? OR accounts.notify_email LIKE ? OR employees.firstname like ? OR employees.lastname LIKE ? OR employees.position LIKE ?', text, text, text, text, text)
    end

    def payment_in?(from, to)
      select{|employee| employee.payments.payment_in?(from, to).total > 0 }
    end

    def not_retired
      where("retired_on IS NULL")
    end

    def enabled
    joins(:person => :account).merge(Account.enabled)
  end
  end

  def account
    person.account
  end

  def employee_account
    person.account.id
  end
  
  def contact
    person.contact
  end
  
  def admin?
    person.admin?
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
    self.person.contact || person.create_contact
  end

  def firstname=(value)
    super
    contact_or_build.firstname = value
    contact_or_build.save!
  end

  def lastname=(value)
    super
    contact_or_build.lastname = value
    contact_or_build.save!
  end

  def position=(value)
    super
    contact_or_build.position = value
    contact_or_build.save!
  end

  def department=(value)
    super
    contact_or_build.department = value
    contact_or_build.save!
  end

  def owner_id=(value)
    super
    contact_or_build.owner_id = value
    contact_or_build.save!
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
    lastname + " " + firstname rescue ""
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

  def retire!
    payments.retire!(retired_on)
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
      I18n.t('models.employee.request')
    else
      I18n.t('models.employee.approve')
    end
  end
end
