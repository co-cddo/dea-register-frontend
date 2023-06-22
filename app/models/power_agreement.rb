class PowerAgreement < ApplicationRecord
  belongs_to :power
  belongs_to :agreement

  def self.populate
    Agreement.find_each do |agreement|
      (agreement.fields["Power Disclosure"] || []).each do |power_id|
        power = Power.find_by!(record_id: power_id)
        find_or_create_by! power:, agreement:
      end
    end
  end
end
