module AirTablePopulate
  def populate_from_air_table(model, name = nil)
    name ||= model.to_s.downcase
    data = {}
    # API returns 100 records at a time.
    # If there are more records, API returns an offset key that needs to be passed into the next query
    while data.empty? || data[:offset].present?
      query = data[:offset].present? ? { offset: data[:offset] } : {}
      data = AirTableApi.data_for("#{AirTableBase.default.base_id}/#{name}", query:)
      data[:records].each do |record|
        instance = model.find_or_initialize_by(record_id: record[:id])
        instance.fields = record[:fields]
        instance.name = record.dig(:fields, :name) || record.dig(:fields, :Name)
        instance.save!
      end
    end
  end
end
