FactoryBot.define do
  factory :agreement do
    name { Faker::Name.name }
    record_id { SecureRandom.uuid }
    sequence :fields do |n|
      { name:, id: n }
    end
  end
end
