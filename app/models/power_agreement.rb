class PowerAgreement < ApplicationRecord
  RAPID_TABLE_NAME = :agreements_powers

  belongs_to :power
  belongs_to :agreement

  class << self
    def populate
      delete_all # Simplest way to ensure records deleted from Airtable do not persist in local database

      air_table_data_source? ? populate_from_airtable : populate_from_rapid
    end

    def populate_from_airtable
      Agreement.find_each do |agreement|
        (agreement.fields["Power Disclosure"] || []).each do |power_id|
          power = Power.find_by(record_id: power_id)
          find_or_create_by!(power:, agreement:) if power.present?
        end
      end
    end

    def populate_from_rapid
      RapidApi.output_for(RAPID_TABLE_NAME).values.each do |record|
        agreement = Agreement.find_by_id!(record[:id])
        power = Power.find_by!(name: record[:name])

        find_or_create_by!(agreement:, power:)
      end
    end
  end
end
