class PowerAgreement < ApplicationRecord
  RAPID_TABLE_NAME = :agreements_powers

  belongs_to :power
  belongs_to :agreement

  class << self
    def populate
      delete_all # Simplest way to ensure records deleted from Airtable do not persist in local database

      populate_from_rapid
    end

    def populate_from_rapid
      RapidApi.output_for(RAPID_TABLE_NAME).each_value do |record|
        agreement = Agreement.find_by_id!(record[:id])
        power = Power.find_by!(name: record[:name])

        find_or_create_by!(agreement:, power:)
      end
    end
  end
end
