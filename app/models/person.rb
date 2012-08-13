class Person < ActiveRecord::Base
  has_one :account
  has_and_belongs_to_many :companies
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :permissions

  has_one :employee
  has_one :enrollment
  has_one :taxman
  has_one :dayworker

  has_one :contact#, dependent: :destroy
  accepts_nested_attributes_for :contact, :allow_destroy => :true, :reject_if => :all_blank
  has_many :contacts, foreign_key: 'owner_id'

  has_many :reporters, class_name: 'ReportPerson'
  has_many :accessors, class_name: 'AccessPerson'

  cattr_accessor :current_person

  def enrollment
    Enrollment.find_by_person_id(id) || create_enrollment!(company_id: Company.current_company.id)
  end

  def self.no_employee
    joins(:account).where('accounts.person_id = people.id') - joins(:employee).where('employees.person_id = people.id')
  end

  def self.with_account
    joins(:account).where('accounts.person_id = people.id')
  end

  def permission?(name)
    admin? or permissions.exists?(name: name.to_s)
  end

  def ingroup?(name)
    self.groups.where(name: name).present?
  end

  def admin?
    self.ingroup?("admin")
  end

  def name
    account.name
  end

  def fullname
    account.fullname
  end

  def joined?
    companies.exists?
  end

  def not_joined?
    not joined?
  end

  def has_payment_info
    not (employee and employee.payments.empty?)
  end
end