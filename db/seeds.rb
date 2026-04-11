# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
puts "Seeding users..."

user1 = User.find_or_initialize_by(email: "1155000001@link.cuhk.edu.hk")
user1.assign_attributes(
  name: "Alice Chan",
  password: "password123",
  password_confirmation: "password123",
  community: 0
)
user1.skip_confirmation!
user1.save!

user2 = User.find_or_initialize_by(email: "1155000002@link.cuhk.edu.hk")
user2.assign_attributes(
  name: "Bob Wong",
  password: "password123",
  password_confirmation: "password123",
  community: 2
)
user2.skip_confirmation!
user2.save!

puts "Seeding items..."

items = [
  { title: "Calculus Textbook (Stewart 8th Ed)", description: "Used for MATH1010. Minor highlighting, good condition.", price: 120, status: :available, community: :chung_chi, user: user1 },
  { title: "TI-84 Plus Calculator",              description: "Works perfectly, includes USB cable and cover.",       price: 350, status: :available, community: :chung_chi, user: user1 },
  { title: "IKEA Desk Lamp",                     description: "White LED desk lamp, adjustable arm. 1 year old.",    price: 50,  status: :sold,      community: :chung_chi, user: user1 },
  { title: "Python Crash Course (3rd Ed)",        description: "Great intro to Python. No marks or damage.",          price: 80,  status: :available, community: :new_asia,  user: user2 },
  { title: "Wireless Keyboard + Mouse Combo",     description: "Logitech MK270. Batteries included.",                price: 100, status: :reserved,  community: :new_asia,  user: user2 },
  { title: "Mini Fridge",                         description: "46L mini fridge, perfect for dorm. Pick up only.",   price: 200, status: :available, community: :new_asia,  user: user2 }
]

items.each do |attrs|
  Item.find_or_create_by!(title: attrs[:title], user: attrs[:user]) do |item|
    item.assign_attributes(attrs.except(:title, :user))
  end
end

puts "Done! Created #{User.count} users and #{Item.count} items."
