FactoryBot.define do
  factory :processor do
    name { Faker::Name.name }
    record_id { SecureRandom.uuid }
    fields { { name: } }
  end
end
