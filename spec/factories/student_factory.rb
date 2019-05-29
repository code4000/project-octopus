FactoryBot.define do
  factory :student do
    first_name { "John" }
    last_name  { "Doe" }

    sequence :email do |n|
      "person#{n}@example.com"
    end

    sequence :prison_number do |n|
      "abc#{n}"
    end
  end

end
