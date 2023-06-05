class AirTable < ApplicationRecord
  extend AirTablePopulate

  def self.populate
    raise "Cannot run on root class - AirTable" if self == AirTable

    populate_from_air_table(self)
  end
end
