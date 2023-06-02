class Person < ApplicationRecord
  def self.populate
    data = {}
    # API returns 100 records at a time.
    # If there are more records, API returns an offset key that needs to be passed into the next query
    while data.empty? || data[:offset].present?
      query = data[:offset].present? ? { offset: data[:offset] } : {}
      data = AirTableApi.data_for("#{AirTableBase.default.base_id}/person", query:)
      data[:records].each do |record|
        person = find_or_initialize_by(record_id: record[:id])
        person.fields = record[:fields]
        person.name = record.dig :fields, :name
        person.save!
      end
    end
  end
end
