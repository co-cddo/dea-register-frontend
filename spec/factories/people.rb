FactoryBot.define do
  factory :person do
    name { Faker::Name.name }
    record_id { SecureRandom.uuid }
  end
end
