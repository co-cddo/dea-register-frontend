# An identity store for each of the tables within the current AirTable base
class AirTableTable < ApplicationRecord
  def self.populate
    data = AirTableApi.data_for("meta/bases/#{AirTableBase.base_id}/tables")
    data[:tables].each do |base|
      air_table_base = find_or_initialize_by(record_id: base[:id])
      air_table_base.name = base[:name]
      air_table_base.save!
    end
  end

  # Converting table names into URL friendly text is problematic.
  # So instead this method is used to find the id that matches the name
  # Then the id can be used within any API URL rather than the name
  def self.id_for_name(name)
    populate if count.zero?
    find_by(name:)&.record_id
  end
end
