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


unless Account.exists?(name: 'admin')
  person = Person.create!
  user = person.create_account(name: 'admin', password: '1234')
  hrinfo = person.create_employee(juminno: '771122-1111111')

  hrinfo.permission.build(name: 'users')
  hrinfo.permission.build(name: 'pettycashes')
  hrinfo.permission.build(name: 'cardbills')
  hrinfo.permission.build(name: 'projects')
  hrinfo.permission.build(name: 'taxbills')
  hrinfo.permission.build(name: 'namecards')
  hrinfo.permission.build(name: 'bank_accounts')
  hrinfo.permission.build(name: 'business_clients')
  hrinfo.permission.build(name: 'commutes')
  hrinfo.permission.build(name: 'ledger_accounts')
  hrinfo.permission.build(name: 'postings')

  hrinfo.groups.build(name: 'admin')

  hrinfo.save!
  person.companies << company
  person.save!  
end

unless Account.exists?(name: "test")
  person2 = Person.create!
  user2 = person2.create_account(name: 'test', password: '1234')
  person2.companies << company
  person2.save!
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


=begin
  

unless User.exists?(name: "admin")
  user = User.create!(name: 'admin', password: '1234')
  person = user.create_person!
  person.create_hrinfo(juminno: '771122-1111111')
  user.person_id = person.id
  # user.person.create_hrinfo(juminno: '771122-1111111')

  user.hrinfo.permission.build(name: 'users')
  user.hrinfo.permission.build(name: 'pettycashes')
  user.hrinfo.permission.build(name: 'cardbills')
  user.hrinfo.permission.build(name: 'projects')
  user.hrinfo.permission.build(name: 'taxbills')
  user.hrinfo.permission.build(name: 'namecards')
  user.hrinfo.permission.build(name: 'bank_accounts')
  user.hrinfo.permission.build(name: 'business_clients')
  user.hrinfo.permission.build(name: 'commutes')
  user.hrinfo.permission.build(name: 'ledger_accounts')
  user.hrinfo.permission.build(name: 'postings')

  user.hrinfo.groups.build(name: 'admin')
  user.person.companies << company
  user.save!
end
  



unless User.exists?(name: "test")
  user = User.create!(name: 'test', password: '1234')

  person = user.create_person!
  person.companies << company
  user.person_id = person.id

  user.save!
end

=end