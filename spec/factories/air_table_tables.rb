FactoryBot.define do
  factory :air_table_table do
    name { Faker::Company.name }
    record_id { SecureRandom.uuid }
  end
end
