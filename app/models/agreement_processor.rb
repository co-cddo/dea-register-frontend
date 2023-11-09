class AgreementProcessor < ApplicationRecord
  belongs_to :agreement
  belongs_to :processor

  def self.populate
    delete_all # Simplest way to ensure records deleted from Airtable do not persist in local database
    Agreement.find_each do |agreement|
      (agreement.fields["Processors"] || []).each do |processor_id|
        processor = Processor.find_by(record_id: processor_id)
        find_or_create_by!(agreement:, processor:) if processor.present?
      end
    end
  end
end
