FactoryBot.define do
  factory :agreement do
    name { Faker::Name.name }
    sequence :record_id
    fields do
      { name:, id: record_id }
    end
  end
end
