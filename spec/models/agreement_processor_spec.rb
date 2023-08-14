require "rails_helper"

RSpec.describe AgreementProcessor, type: :model do
  describe ".populate" do
    subject(:populate) { described_class.populate }

    let!(:processor) { create :processor }
    let!(:agreement) do
      agreement = build(:agreement)
      agreement.fields["Processors"] = [processor.record_id]
      agreement.save!
      agreement
    end

    it "creates a new instance" do
      expect { populate }.to change(described_class, :count).by(1)
    end

    it "associates the agreement with the processor" do
      populate
      expect(agreement.reload.processors).to include(processor)
    end

    it "associates the processor with the agreement" do
      populate
      expect(processor.reload.agreements).to include(agreement)
    end

    describe "with an existing instance" do
      let!(:agreement_processor) { create :agreement_processor }

      it "associates the agreement with the processor" do
        populate
        expect(agreement.reload.processors).to include(processor)
      end

      it "deleted the existing association" do
        expect { populate }.not_to change(described_class, :count) # +1 new, -1 old removed = 0
      end

      it "existing to be removed" do
        populate
        expect(described_class.find_by(agreement_processor.attributes)).to be_nil
      end
    end
  end
end
