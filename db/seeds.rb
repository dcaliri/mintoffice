# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

unless Company.all.empty?
  company = Company.create!(name: "mintech")
  company.save!
end

company = Company.find_by_name("mintech")
Company.current_company = company

unless Account.exists?(name: 'admin')
  person = Person.create!
  account = person.create_account(name: 'admin', password: '1234')
  Account.current_account = accout
  
  employee = person.create_employee(juminno: '771122-1111111')

  employee.person.permissions.build(name: 'users')
  employee.person.permissions.build(name: 'pettycashes')
  employee.person.permissions.build(name: 'cardbills')
  employee.person.permissions.build(name: 'projects')
  employee.person.permissions.build(name: 'taxbills')
  employee.person.permissions.build(name: 'namecards')
  employee.person.permissions.build(name: 'bank_accounts')
  employee.person.permissions.build(name: 'business_clients')
  employee.person.permissions.build(name: 'commutes')
  employee.person.permissions.build(name: 'ledger_accounts')
  employee.person.permissions.build(name: 'postings')

  employee.person.groups.build(name: 'admin')

  employee.save!
  person.companies << company
  person.save! 
  account.save!
end

unless Account.exists?(name: "test")
  person = Person.create!
  account = person.create_account(name: 'test', password: '1234')
  Account.current_account = accout

  person.companies << company
  person.save!
  account.save!
end


if company.contact_address_tags.empty?
  company.contact_address_tags.create!(name: "집")
  company.contact_address_tags.create!(name: "직장")
end

if company.contact_email_tags.empty?
  company.contact_email_tags.create!(name: "집")
  company.contact_email_tags.create!(name: "주소")
end

if company.contact_phone_number_tags.empty?
  company.contact_phone_number_tags.create!(name: "집")
  company.contact_phone_number_tags.create!(name: "회사")
  company.contact_phone_number_tags.create!(name: "핸드폰")
end


if company.contact_other_tags.empty?
  company.contact_other_tags.create!(name: "홈페이지")
  company.contact_other_tags.create!(name: "트위터")
  company.contact_other_tags.create!(name: "페이스북")
end

if LedgerAccount.all.empty?
  LedgerAccount.create!(title: "현금", category: "자본")
  LedgerAccount.create!(title: "신용카드", category: "부채")
end