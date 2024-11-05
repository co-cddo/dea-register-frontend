FactoryBot.define do
  factory :data_table do
    name { Faker::Company.industry }
    record_id { rand(1..100) }
    type { %w[Agreement Power ControlPerson].sample }

    # NOTE: DataTable is an abstract (STI) class
    # Line below ensures object returned is the type's class and not AirTable
    initialize_with { type.constantize.new }
  end
end
