class Power < ApplicationRecord
  def self.populate
    data = {}
    # API returns 100 records at a time.
    # If there are more records, API returns an offset key that needs to be passed into the next query
    while data.empty? || data[:offset].present?
      query = data[:offset].present? ? { offset: data[:offset] } : {}
      data = AirTableApi.data_for("#{AirTableBase.default.base_id}/power", query:)
      data[:records].each do |record|
        power = find_or_initialize_by(record_id: record[:id])
        power.fields = record[:fields]
        power.name = record.dig :fields, :name
        power.save!
      end
    end
  end
end
