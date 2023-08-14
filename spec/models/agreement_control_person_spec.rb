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

    describe "with an existing instance" do
      let!(:agreement_control_person) { create :agreement_control_person }

      it "associates the agreement with the control person" do
        populate
        expect(agreement.reload.control_people).to include(control_person)
      end

      it "deleted the existing association" do
        expect { populate }.not_to change(described_class, :count) # +1 new, -1 old removed = 0
      end

      it "existing to be removed" do
        populate
        expect(described_class.find_by(agreement_control_person.attributes)).to be_nil
      end
    end
  end

  describe "associated object behaviour" do
    let(:agreement_control_person) { create :agreement_control_person }
    let(:database_record) do
      described_class.find_by(
        agreement: agreement_control_person.agreement,
        control_person: agreement_control_person.control_person,
      )
    end

    it "when agreement destroyed, it is removed from database" do
      agreement_control_person.agreement.destroy!
      expect(database_record).to be_nil
    end

    it "when control person destoryed, it is removed from database" do
      agreement_control_person.control_person.destroy!
      expect(database_record).to be_nil
    end

    it "when nothing destroyed, record is found" do
      expect(database_record).to be_a(described_class)
    end
  end
end
