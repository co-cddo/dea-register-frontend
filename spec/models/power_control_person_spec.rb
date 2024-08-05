require "rails_helper"

RSpec.describe PowerControlPerson, type: :model do
  describe ".populate" do
    subject(:populate) { described_class.populate }

    let!(:control_person) { create :control_person }

    context "with airtable source" do
      let!(:power) do
        power = build(:power)
        power.fields["Person"] = [control_person.record_id]
        power.save!
        power
      end

      it "creates a PowerAgreement" do
        expect { populate }.to change(described_class, :count).by(1)
      end

      it "associates the control person with the power" do
        populate
        expect(control_person.reload.powers).to include(power)
      end

      it "associates the power with the control person" do
        populate
        expect(power.reload.control_people).to include(control_person)
      end
    end

    context "with rAPId source" do
      before do
        allow(Rails.configuration).to receive(:data_source).and_return(:rapid)
      end

      it "does nothing" do # no matching rAPId table
        expect { populate }.not_to change(described_class, :count)
      end
    end
  end
end
