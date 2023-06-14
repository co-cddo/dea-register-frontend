# Added AirTable prefix as having a class called Base could be problematic
# The base is the root object that defines which set of data is being retrieved
# The id of the base is needed for API calls for sub-objects
class AirTableBase < ApplicationRecord
  class << self
    def default
      @default ||= begin
        populate if count.zero?
        first # Assume api key only allows access to one base so default will be the first and only
      end
    end

    delegate :base_id, to: :default

    def populate
      data = AirTableApi.data_for("/meta/bases")
      data[:bases].each do |base|
        air_table_base = find_or_initialize_by(base_id: base[:id])
        air_table_base.name = base[:name]
        air_table_base.permission_level = base[:permissionLevel]
        air_table_base.save!
      end
    end
  end
end
