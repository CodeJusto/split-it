# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

5.times do 
  User.create(name: Faker::Name.name, email: Faker::Internet.email, password: 'password' )
end

User.create(name: "Chadster", email: "ceebs@faith.com", password: 'password', final_boss: true)


Role.create(role_text: "Organizer")
Role.create(role_text: "Contributor")

Status.create(text: "Pending")
Status.create(text: "Active")
Status.create(text: "Cancelled")
Status.create(text: "Achieved")
Status.create(text: "Shipped")
Status.create(text: "Archived")