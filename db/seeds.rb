# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
require 'securerandom'

%w(account check cistack ciworker dashboard deploy environment group project replica repository permission role script step task user validation_job workflow).each do |o|
Permission.create(name: "Create #{o}", key: "c-#{o}", module: "#{o}")
Permission.create(name: "Delete #{o}", key: "d-#{o}", module: "#{o}")
Permission.create(name: "Update #{o}", key: "u-#{o}", module: "#{o}")
Permission.create(name: "Read #{o}",   key: "r-#{o}", module: "#{o}")
end
Role.create(name: "Admin")
Role.create(name: "CIAdmin")
Role.create(name: "CDAdmin")
Role.create(name: "CVAdmin")
Role.create(name: "Developer")
Role.find_by_name("Admin").permissions << Permission.all
Role.find_by_name("CIAdmin").permissions << Permission.where("module = 'cistack'")
Role.find_by_name("CIAdmin").permissions << Permission.where("module = 'ciworker'")
Role.find_by_name("CIAdmin").permissions << Permission.where("module = 'project'")
Role.find_by_name("CIAdmin").permissions << Permission.where("module = 'replica'")
Role.find_by_name("CIAdmin").permissions << Permission.where("module = 'repository'")
Role.find_by_name("CDAdmin").permissions << Permission.where("module = 'task'")
Role.find_by_name("CDAdmin").permissions << Permission.where("module = 'workflow'")
Role.find_by_name("CDAdmin").permissions << Permission.where("module = 'deploy'")
Role.find_by_name("CDAdmin").permissions << Permission.where("module = 'step'")
Role.find_by_name("CVAdmin").permissions << Permission.where("module = 'dashboard'")
Role.find_by_name("CVAdmin").permissions << Permission.where("module = 'check'")
Role.find_by_name("CVAdmin").permissions << Permission.where("module = 'validation_job'")
Account.create(name: "continuous_Administrator", uuid: "#{SecureRandom.uuid}")
User.create(username: "Administrator", name: "Administrator", uuid: "#{SecureRandom.uuid}", email: "admin@example.com", password: "password")
Account.find_by_name("continuous_Administrator").users << User.find_by_username("Administrator")
User.find_by_username("Administrator").roles << Role.find_by_name("Admin")

