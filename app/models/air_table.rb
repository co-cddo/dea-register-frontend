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
  include PgSearch::Model
  multisearchable against: %i[name fields]

  scope :where_first_letter, lambda { |letter|
    where("substr(name, 1, 1) = ? OR substr(name, 1, 1) = ?", letter.upcase, letter.downcase)
  }

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
      created_ids = []
      # API returns 100 records at a time.
      # If there are more records, API returns an offset key that needs to be
      # passed into the next query
      while data.empty? || data[:offset].present?
        query = data[:offset].present? ? { offset: data[:offset] } : {}
        data = AirTableApi.data_for(air_table_path, query:)
        data[:records].each do |record|
          next if record[:fields].empty?

          instance = find_or_initialize_by(record_id: record[:id])

          name = record.dig(:fields, :name) || record.dig(:fields, :Name)

          # If name divided in two by a colon only use the last part in the instance name
          name = name.split(":").last.strip if name&.count(":") == 1
          instance.name = name

          instance.fields = record[:fields]
          instance.save!
          created_ids << instance.id
        end
      end
      # Remove records that no longer match any on Airtable (assume deleted)
      where.not(id: created_ids).destroy_all
    end

    def air_table_path
      table_id = AirTableTable.id_for_name(air_table_name)
      "#{AirTableBase.base_id}/#{table_id}"
    end
  end
end
