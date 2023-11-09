class PowerControlPerson < ApplicationRecord
  belongs_to :power
  belongs_to :control_person

  def self.populate
    Power.find_each do |power|
      (power.fields["Person"] || []).each do |person_id|
        control_person = ControlPerson.find_by(record_id: person_id)
        find_or_create_by!(power:, control_person:) if control_person.present?
      end
    end
  end
end
