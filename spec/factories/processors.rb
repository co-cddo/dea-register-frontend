FactoryBot.define do
  factory :processor do
    name { Faker::Name.name }
    record_id { rand(1..100) }
    fields { { name: } }
  end
end
