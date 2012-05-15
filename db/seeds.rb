# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

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
  user.permission.build(name: 'business_clients')

  user.groups.build(name: 'admin')

  user.save!
end

if ContactAddressTag.all.empty?
  ContactAddressTag.create!(name: "집")
  ContactAddressTag.create!(name: "직장")
end

if ContactEmailTag.all.empty?
  ContactEmailTag.create!(name: "집")
  ContactEmailTag.create!(name: "주소")
end

if ContactPhoneNumberTag.all.empty?
  ContactPhoneNumberTag.create!(name: "집")
  ContactPhoneNumberTag.create!(name: "회사")
  ContactPhoneNumberTag.create!(name: "핸드폰")
end


if ContactOtherTag.all.empty?
  ContactOtherTag.create!(name: "홈페이지")
  ContactOtherTag.create!(name: "트위터")
  ContactOtherTag.create!(name: "페이스북")
end