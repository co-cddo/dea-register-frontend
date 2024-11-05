FactoryBot.define do
  factory :control_person do
    name { Faker::Name.name }
    record_id { rand(1..100) }
    fields { { name: } }
  end
end
