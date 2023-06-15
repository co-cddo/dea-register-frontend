class PowerAgreement < ApplicationRecord
  belongs_to :power
  belongs_to :agreement

  def self.populate
    Power.all.find_each do |power|
      (power.fields["Agreement"] || []).each do |agreement_id|
        agreement = Agreement.find_by!(record_id: agreement_id)
        find_or_create_by! power:, agreement:
      end
    end
  end
end
