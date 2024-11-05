FactoryBot.define do
  factory :agreement do
    name { Faker::Name.name }
    record_id { rand(1..100) }
    sequence :fields do |n|
      { name:, id: n }
    end
  end
end
