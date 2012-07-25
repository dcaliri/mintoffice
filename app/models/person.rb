class Person < ActiveRecord::Base
  has_one :user
  has_and_belongs_to_many :companies

  has_one :hrinfo
  has_one :enrollment
  has_one :taxman

  has_one :contact, dependent: :destroy
  has_many :contacts, foreign_key: 'owner_id'

  has_many :reporters, class_name: 'ReportPerson'
  has_many :accessors, class_name: 'AccessPerson'

  def self.nohrinfo
    joins(:user).where('users.person_id == people.id') - joins(:hrinfo).where('hrinfos.person_id == people.id')
  end

  def name
    user.name
  end

  def joined?
    companies.exists?
  end

  def not_joined?
    not joined?
  end
end