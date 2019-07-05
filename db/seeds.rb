# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

PublicActivity.enabled = false

puts ""
puts "Creating seed data..."
User.create(name: "Master User", email: "admin@yoomee.com", password: "10gm31n10gm31n", role: "master")
puts ""
puts "Created admin user <admin@yoomee.com> with password '10gm31n10gm31n'"
puts ""

# Create HMP site data
for i in 1..20 do
  d = Site.create(  name: "HMP "+Faker::Movies::LordOfTheRings.location,
                capacity: rand(15...30),
                manager: Faker::FunnyName.two_word_name,
                gender: Faker::Gender.binary_type,
                contact_number: "0"+Faker::Number.number(10))
  puts "Created dummy HMP site #{i}: #{d.name}"

end

# Create company site data
puts ""
for i in 1..50 do
  d = Site.create(  name: (Faker::Company.buzzword + " " +Faker::Commerce.material + " " + Faker::Company.suffix).titleize,
                capacity: rand(5...10),
                manager: Faker::TvShows::BreakingBad.character,
                gender: Faker::Gender.binary_type,
                contact_number: "0"+Faker::Number.number(10))
  puts "Created dummy company site #{i}: #{d.name}"

end

# Create students  data
puts ""
for i in 1..100 do
  d = Student.create( site: Site.order('RANDOM()').first,
                  first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  prison_number: (Faker::Alphanumeric.alpha(1)+Faker::Number.number(4)+Faker::Alphanumeric.alpha(2)).upcase,
                  gender: Faker::Gender.binary_type,
                  dob: Faker::Date.between(18.years.ago, 40.years.ago),
                  crd: Faker::Date.between(2.years.ago, Date.today),
                  hdc: Faker::Date.between(2.years.ago, Date.today),
                  rotl: Faker::Date.between(2.years.ago, Date.today),
                  recat: Faker::Date.between(2.years.ago, Date.today),
                  contact_number: "07"+Faker::Number.number(9),
                  email: Faker::Internet.email
  )
  puts "Created dummy student #{i}: #{d.first_name} #{d.last_name}"

end

puts ""
# Create contacts data
for i in 1..100 do
  d = Contact.create(
                  first_name: Faker::Name.first_name,
                  last_name: Faker::Name.last_name,
                  role: Faker::Job.seniority + " " + Faker::Job.position,
                  organisation: (Faker::Company.buzzword + " " +Faker::Commerce.material + " " + Faker::Company.suffix).titleize,
                  mobile_number: "07"+Faker::Number.number(9),
                  work_number: "01"+Faker::Number.number(9),
                  email: Faker::Internet.email,
                  about: Faker::Job.employment_type + " " + Faker::ProgrammingLanguage.name + " " + Faker::Job.position
  )
  puts "Created dummy contact #{i}: #{d.first_name} #{d.last_name}"

end

PublicActivity.enabled = true
