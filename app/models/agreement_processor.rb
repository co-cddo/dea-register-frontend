class AgreementProcessor < ApplicationRecord
  RAPID_TABLE_NAME = :agreements_processors

  belongs_to :agreement
  belongs_to :processor

  class << self
    def populate
      delete_all # Simplest way to ensure records deleted from Airtable do not persist in local database

     air_table_data_source? ? populate_from_airtable : populate_from_rapid
    end

    def populate_from_airtable
      Agreement.find_each do |agreement|
        (agreement.fields["processors"] || []).each do |processor_id|
          processor = Processor.find_by(record_id: processor_id)
          find_or_create_by!(agreement:, processor:) if processor.present?
        end
      end
    end

    def populate_from_rapid
      RapidApi.output_for(RAPID_TABLE_NAME).values.each do |record|
        agreement = Agreement.find_by_id!(record[:id])
        processor = Processor.find_by!(name: record[:processor_name])

        find_or_create_by!(agreement:, processor:)
      end
    end
  end
end
