FactoryBot.define do
  factory :control_person do
    name { Faker::Name.name }
    record_id { SecureRandom.uuid }
    fields { { name: } }
  end
end
