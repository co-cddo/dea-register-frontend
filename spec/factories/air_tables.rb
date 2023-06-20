FactoryBot.define do
  factory :air_table do
    name { Faker::Company.industry }
    record_id { SecureRandom.uuid }
    type { %w[Agreement Power ControlPerson].sample }

    # NOTE: AirTable is an abstract (STI) class
    # Line below ensures object returned is the type's class and not AirTable
    initialize_with { type.constantize.new }
  end
end
