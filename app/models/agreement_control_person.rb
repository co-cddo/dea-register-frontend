class AgreementControlPerson < ApplicationRecord
  RAPID_TABLE_NAME = :agreements_controllers

  belongs_to :agreement
  belongs_to :control_person

  class << self
    def populate
      delete_all # Simplest way to ensure records deleted from Airtable do not persist in local database

      air_table_data_source? ? populate_from_airtable : populate_from_rapid
    end

    def populate_from_airtable
      Agreement.find_each do |agreement|
        (agreement.fields["controllers"] || []).each do |control_person_id|
          control_person = ControlPerson.find_by(record_id: control_person_id)
          find_or_create_by!(agreement:, control_person:) if control_person.present?
        end
      end
    end

    def populate_from_rapid
      RapidApi.output_for(RAPID_TABLE_NAME).values.each do |record|
        agreement = Agreement.find_by_id!(record[:id])
        control_person = ControlPerson.find_by!(name: record[:controller_name])

        find_or_create_by!(agreement:, control_person:)
      end
    end
  end
end
