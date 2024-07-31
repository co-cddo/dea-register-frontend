module RapidDataSource
  def data_from_rapid
    data = RapidApi.output_for(rapid_table_name)

    data.values.each_with_object({}) do |record, hash|
      record[:name] = record[rapid_name_field]
      hash[record[:id]] = record
    end
  end
end
