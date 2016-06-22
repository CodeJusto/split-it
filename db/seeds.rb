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

User.create(name: "Justin", email: "justincwong89@gmail.com", password: 'password', number: "7782286061")
User.create(name: "Patrick", email: "pengj@ceebs.faith", password: 'password', number: "6048050993")
User.create(name: "Chad", email: "ceebs@ceebs.faith", password: 'password', final_boss: true, number: "7782312831")

Cart.create(status_id: 1, expiry: Time.new(2016, 8, 31), name: "New couch for the office", country: "Canada", street_address: "19-8591 Blundell Road", city: "Richmond", province: "British Columbia", zip_code: "V6Y 1K2")

User.all.each do |user|
  CartRole.create(user_id: user.id, cart_id: 1, role_id: 2, email_notifications: false, text_notifications: false)
end


@role = CartRole.find(6)
@role.role_id = 1
@role.email_notifications = true
@role.text_notifications = true
@role.save

Role.create(role_text: "Organizer")
Role.create(role_text: "Contributor")

Status.create(text: "Pending")
Status.create(text: "Active")
Status.create(text: "Cancelled")
Status.create(text: "Achieved")
Status.create(text: "Shipped")
Status.create(text: "Archived")

NotificationTemplate.create(description: "Welcome")
NotificationTemplate.create(description: "Contribution")
NotificationTemplate.create(description: "Success")
NotificationTemplate.create(description: "Failure")