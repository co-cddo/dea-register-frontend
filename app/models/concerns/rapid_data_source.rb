module RapidDataSource
  def data_from_rapid
    data = RapidApi.output_for(rapid_table_name)

    data.each_with_object({}) do |(_key, record), hash|
      record[:name] = record[rapid_name_field]
      hash[record.fetch(:id, record[:name])] = record # Identifiy via the id within the record if present, else use name
    end
  end
end
