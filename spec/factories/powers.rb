FactoryBot.define do
  factory :power do
    name { Faker::Name.name }
    record_id { SecureRandom.uuid }
    fields { { status: "active", name: } }

    trait :retired do
      fields { { status: "retired", name: } }
    end
  end
end
