class AirTable < ApplicationRecord
  extend AirTablePopulate

  class << self
    attr_accessor :air_table_name

    def populate
      raise "Cannot run on root class - AirTable" if self == AirTable

      populate_from_air_table(self, air_table_name)
    end
  end
end
