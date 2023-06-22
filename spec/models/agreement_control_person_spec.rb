require "rails_helper"

RSpec.describe AgreementControlPerson, type: :model do
  describe ".populate" do
    subject(:populate) { described_class.populate }

    let!(:control_person) { create :control_person }
    let!(:agreement) do
      agreement = build(:agreement)
      agreement.fields["Controllers"] = [control_person.record_id]
      agreement.save!
      agreement
    end

    it "creates a new instance" do
      expect { populate }.to change(described_class, :count).by(1)
    end

    it "associates the agreement with the control person" do
      populate
      expect(agreement.reload.control_people).to include(control_person)
    end

    it "associates the control person with the agreement" do
      populate
      expect(control_person.reload.agreements).to include(agreement)
    end
  end
end
