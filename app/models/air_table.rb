# Classes that inherit from this one store data for each of the Airtable tables
# For example, if you want to store the data for an AirTable table "Foo bar" you can:
# ```
#   class FooBar < AirTable
#     self.air_table_name = 'Foo bar'
#   end
# ```
#
# With that in place, `FooBar.populate` will pull each of the records from AirTable and
# store them in the air_tables table with the type 'FooBar'.
class AirTable < ApplicationRecord
  class << self
    attr_accessor :air_table_name

    def populate
      raise "Cannot run on root class - AirTable" if self == AirTable

      populate_from_air_table
    end

    def search(text)
      query = { "filterByFormula" => %[SEARCH("#{text}",{Name})] }
      data = AirTableApi.data_for(air_table_path, query:)
      return none if data[:records].empty?

      ids = data[:records].pluck(:id)
      where(record_id: ids)
    end

  private

    def populate_from_air_table
      data = {}
      # API returns 100 records at a time.
      # If there are more records, API returns an offset key that needs to be
      # passed into the next query
      while data.empty? || data[:offset].present?
        query = data[:offset].present? ? { offset: data[:offset] } : {}
        data = AirTableApi.data_for(air_table_path, query:)
        data[:records].each do |record|
          next if record[:fields].empty?

          instance = find_or_initialize_by(record_id: record[:id])
          instance.fields = record[:fields]
          instance.name = record.dig(:fields, :name) || record.dig(:fields, :Name)
          instance.save!
        end
      end
    end

    def air_table_path
      table_id = AirTableTable.id_for_name(air_table_name)
      "#{AirTableBase.base_id}/#{table_id}"
    end
  end
end
