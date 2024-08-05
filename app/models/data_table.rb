# Classes that inherit from this one store data for each of the main data tables

# For data held in Airtable, the table name used in Airtable will need to be defined
# in the sub-classes. For example, if you want to store the data for an Airtable "Foo bar"
# you can:
# ```
#   class FooBar < DataTable
#     self.air_table_name = 'Foo bar'
#   end
# ```
#
# With that in place, `FooBar.populate` will pull each of the records from the data source
# and store them in the data_tables table with the type 'FooBar'.
class DataTable < ApplicationRecord
  extend AirtableDataSource
  extend RapidDataSource

  include PgSearch::Model
  multisearchable against: %i[name fields]

  scope :where_first_letter, lambda { |letter|
    where("substr(name, 1, 1) = ? OR substr(name, 1, 1) = ?", letter.upcase, letter.downcase)
  }

  class << self
    attr_accessor :air_table_name, :rapid_table_name, :rapid_name_field

    def populate
      raise "Cannot run on root class - DataTable" if self == DataTable

      ids_of_created = data_from_source.map do |id, record|
        record.transform_keys! { |r| r.to_s.parameterize(separator: '_').to_sym }
        instance = find_or_initialize_by(record_id: id)

        name = record[:name]
        name = name.split(":").last if name&.count(":") == 1
        instance.name = name.strip

        instance.fields = record
        instance.save!
        instance.id
      end
      # Remove records that no longer match any on the source system(assume deleted)
      where.not(id: ids_of_created).destroy_all
    end

    def data_from_source
      air_table_data_source? ? data_from_air_table : data_from_rapid
    end

    def search(text)
      search_via_air_table(text)
    end

  private

    def is_draft?(record)
      sync_status = record.dig(:fields, :Sync_Status)
      return if sync_status.blank?

      sync_status.downcase == "draft"
    end
  end
end
