class AgreementControlPerson < ApplicationRecord
  belongs_to :agreement
  belongs_to :control_person

  def self.populate
    Agreement.find_each do |agreement|
      (agreement.fields["Controllers"] || []).each do |control_person_id|
        control_person = ControlPerson.find_by(record_id: control_person_id)
        find_or_create_by! agreement:, control_person:
      end
    end
  end
end
