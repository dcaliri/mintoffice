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

unless User.exists?(name: "admin")
  user = User.new
  user.name = "admin"
  user.password = "1234"

  user.permission.build(name: 'users')
  user.permission.build(name: 'pettycashes')
  user.permission.build(name: 'cardbills')
  user.permission.build(name: 'projects')
  user.permission.build(name: 'taxbills')
  user.permission.build(name: 'namecards')
  user.permission.build(name: 'bank_accounts')
  user.permission.build(name: 'business_clients')
  user.permission.build(name: 'commutes')
  user.permission.build(name: 'ledger_accounts')
  user.permission.build(name: 'postings')

  user.groups.build(name: 'admin')
  user.companies << company
  user.save!
end

unless User.exists?(name: "test")
  user = User.new
  user.name = "test"
  user.password = "1234"

  user.companies << company
  user.save!
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