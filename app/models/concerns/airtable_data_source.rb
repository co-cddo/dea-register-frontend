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

  def data_from_air_table
    data = {}
    records = {}
    # API returns 100 records at a time.
    # If there are more records, API returns an offset key that needs to be
    # passed into the next query
    while data.empty? || data[:offset].present?
      query = data[:offset].present? ? { offset: data[:offset] } : {}
      data = AirTableApi.data_for(air_table_path, query:)
      data[:records].each do |record|
        next if record[:fields].empty?
        next if is_draft?(record)

        records[record[:id]] = record[:fields]
      end
    end
    records
  end

  def air_table_path
    table_id = AirTableTable.id_for_name(air_table_name)
    "#{AirTableBase.base_id}/#{table_id}"
  end
end
