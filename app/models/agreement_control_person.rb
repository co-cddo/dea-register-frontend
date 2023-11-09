class AgreementControlPerson < ApplicationRecord
  belongs_to :agreement
  belongs_to :control_person

  def self.populate
    delete_all # Simplest way to ensure records deleted from Airtable do not persist in local database
    Agreement.find_each do |agreement|
      (agreement.fields["Controllers"] || []).each do |control_person_id|
        control_person = ControlPerson.find_by(record_id: control_person_id)
        find_or_create_by!(agreement:, control_person:) if control_person.present?
      end
    end
  end
end
