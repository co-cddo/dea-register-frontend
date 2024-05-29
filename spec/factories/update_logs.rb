FactoryBot.define do
  factory :update_log do
    updated_on { 2.days.ago.to_date }
    comment { Faker::Lorem.sentence }
  end
end
