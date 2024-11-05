FactoryBot.define do
  factory :air_table_table do
    name { Faker::Company.name }
    record_id { rand(1..100) }
  end
end
