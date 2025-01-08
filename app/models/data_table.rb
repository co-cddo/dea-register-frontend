# Classes that inherit from this one store data for each of the main data tables

# Subclasses of DataTable need to specify the name of the rAPId table the data
# will be pulled from and which field contains the instance name:
# ```
#   class FooBar < DataTable
#     self.rapid_table_name = :my_model
#     self.rapid_name_field = :my_model_name
#   end
# ```
#
# With that in place, `FooBar.populate` will pull each of the records from the data source
# and store them in the data_tables table with the type 'FooBar'.
class DataTable < ApplicationRecord
  extend RapidDataSource

  include PgSearch::Model
  multisearchable against: %i[name fields]

  scope :where_first_letter, lambda { |letter|
    where("substr(name, 1, 1) = ? OR substr(name, 1, 1) = ?", letter.upcase, letter.downcase)
  }

  class << self
    attr_accessor :rapid_table_name, :rapid_name_field

    def populate
      raise "Cannot run on root class - DataTable" if self == DataTable

      ids_of_created = data_from_source.map do |id, record|
        record.transform_keys! { |r| r.to_s.parameterize(separator: "_").to_sym }
        instance = find_or_initialize_by(record_id: id)

        name = record[:name]

        next if name.blank?

        name = name.split(":").last if name&.count(":") == 1

        instance.name = name.strip

        instance.fields = SourceRecordCleaner.clean(record)
        before_populate_save(instance)
        instance.save!
        instance.id
      end
      # Remove records that no longer match any on the source system(assume deleted)
      where.not(id: ids_of_created).destroy_all
    end

    def before_populate_save(instance)
      # By default do nothing
      # Override in child classes to add modifications specific to that class
    end

    def data_from_source
      data_from_rapid
    end

  private

    def is_draft?(record)
      sync_status = record.dig(:fields, :Sync_Status)
      return if sync_status.blank?

      sync_status.downcase == "draft"
    end
  end
end
