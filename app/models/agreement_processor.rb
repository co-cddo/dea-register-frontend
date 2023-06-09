class AgreementProcessor < ApplicationRecord
  belongs_to :agreement
  belongs_to :processor

  def self.populate
    Agreement.find_each do |agreement|
      (agreement.fields["Processors"] || []).each do |processor_id|
        processor = Processor.find_by(record_id: processor_id)
        find_or_create_by! agreement:, processor:
      end
    end
  end
end
