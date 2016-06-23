# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(name: "Don Burks", email: "DonB@ceebs.faith", password: 'password', image: "https://www.lighthouselabs.ca/uploads/team_member/avatar/2/medium_don.JPG")
User.create(name: "David VanDusen", email: "DavidV@ceebs.faith", password: 'password', image: 'https://s3.amazonaws.com/lighthouse-compass/uploads/teacher/custom_avatar/192/thumb_beardy.jpeg')
User.create(name: "Monica Olinescu", email: "MonicaO@ceebs.faith", password: "password", image: 'https://s3.amazonaws.com/lighthouse-compass/uploads/teacher/custom_avatar/139/thumb_picture_lighthouse.png')
User.create(name: "Khurram Virani", email: "KhurramV@ceebs.faith", password: "password", image: 'https://s3.amazonaws.com/lighthouse-compass/uploads/teacher/custom_avatar/1/thumb_khurram-virani-2.jpg')
User.create(name: "James Sapara", email: "JamesS@ceebs.faith", password: "password", image: "https://avatars.githubusercontent.com/u/118081?v=3")
User.create(name: "Jeremy Holman", email: "JeremyH@ceebs.faith", password: "password", image: "https://avatars.githubusercontent.com/u/172523?v=3")

User.create(name: "Justin", email: "justincwong89@gmail.com", password: 'password', number: "7782286061", image: "https://scontent.fsnc1-2.fna.fbcdn.net/v/t1.0-1/p160x160/11002626_10205136913775914_5838250906441272135_n.jpg?oh=30f4e6a97a518bc88179a0e454d5262b&oe=58053257")

Cart.create(status_id: 1, expiry: Time.new(2016, 8, 31), name: "New couch for the office", country: "Canada", street_address: "19-8591 Blundell Road", city: "Richmond", province: "British Columbia", zip_code: "V6Y 1K2")

User.all.each do |user|
  CartRole.create(user_id: user.id, cart_id: 1, role_id: 2, email_notifications: false, text_notifications: false)
end


@role = CartRole.find(7)
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