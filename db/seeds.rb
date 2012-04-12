# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
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
