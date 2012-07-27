class Person < ActiveRecord::Base
  has_one :account
  has_and_belongs_to_many :companies
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :permissions

  has_one :employee
  has_one :enrollment
  has_one :taxman

  has_one :contact, dependent: :destroy
  has_many :contacts, foreign_key: 'owner_id'

  has_many :reporters, class_name: 'ReportPerson'
  has_many :accessors, class_name: 'AccessPerson'

  def self.noemployee
    joins(:account).where('accounts.person_id == people.id') - joins(:employee).where('employees.person_id == people.id')
  end

  def name
    account.name
  end

  def joined?
    companies.exists?
  end

  def not_joined?
    not joined?
  end
end