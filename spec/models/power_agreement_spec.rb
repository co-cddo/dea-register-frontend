require "rails_helper"

RSpec.describe PowerAgreement, type: :model do
  describe ".populate" do
    subject(:populate) { described_class.populate }

    let!(:power) { create :power }
    let!(:agreement) do
      agreement = build(:agreement)
      agreement.fields["Power Disclosure"] = [power.record_id]
      agreement.save!
      agreement
    end

    it "creates a PowerAgreement" do
      expect { populate }.to change(described_class, :count).by(1)
    end

    it "associates the agreement with the power" do
      populate
      expect(agreement.reload.powers).to include(power)
    end

    it "associates the power with the agreement" do
      populate
      expect(power.reload.agreements).to include(agreement)
    end
  end
end
