# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

puts ""
puts "Creating seed data..."
User.create(name: "Master User", email: "admin@yoomee.com", password: "logmein", role: "master")
puts ""
puts "Created admin user <admin@yoomee.com> with password 'logmein'"
puts ""

