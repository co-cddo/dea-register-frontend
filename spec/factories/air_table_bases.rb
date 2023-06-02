FactoryBot.define do
  factory :air_table_base do
    name { Faker::Company.name }
    permission_level { %w[none read comment edit create].sample }
    base_id { SecureRandom.uuid }
  end
end
