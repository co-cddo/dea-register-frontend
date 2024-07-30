# Use in data tables where source of data is (can be) Airtable.
# Add the class via extend. For example:
#
#     class FooBar < DataTable
#       extend AirtableDataSource
#

module AirtableDataSource
  def search_via_air_table(text)
    query = { "filterByFormula" => %[SEARCH("#{text}",{Name})] }
    data = AirTableApi.data_for(air_table_path, query:)
    return none if data[:records].empty?

    ids = data[:records].pluck(:id)
    where(record_id: ids)
  end

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
        next if is_draft?(record)

        instance = find_or_initialize_by(record_id: record[:id])

        name = record.dig(:fields, :name) || record.dig(:fields, :Name) || ""

        # If name divided in two by a colon only use the last part in the instance name
        name = name.split(":").last if name&.count(":") == 1
        instance.name = name.strip

        instance.fields = record[:fields].transform_keys(&:downcase)
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
