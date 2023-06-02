FactoryBot.define do
  factory :power do
    name { Faker::Company.industry }
    record_id { SecureRandom.uuid }
  end
end
