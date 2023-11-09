class PowerAgreement < ApplicationRecord
  belongs_to :power
  belongs_to :agreement

  def self.populate
    delete_all # Simplest way to ensure records deleted from Airtable do not persist in local database
    Agreement.find_each do |agreement|
      (agreement.fields["Power Disclosure"] || []).each do |power_id|
        power = Power.find_by(record_id: power_id)
        find_or_create_by!(power:, agreement:) if power.present?
      end
    end
  end
end
