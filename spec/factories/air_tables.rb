FactoryBot.define do
  factory :air_table do
    name { Faker::Company.industry }
    record_id { SecureRandom.uuid }
    type { %w[People Party Agreement Power].sample }
  end
end
