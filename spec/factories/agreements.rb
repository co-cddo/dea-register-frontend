FactoryBot.define do
  factory :agreement do
    name { Faker::Name.name }
    record_id { SecureRandom.uuid }
    fields { { name: } }
  end
end
