require "rails_helper"

RSpec.describe AgreementProcessor, type: :model do
  describe ".populate" do
    subject(:populate) { described_class.populate }

    let!(:processor) { create :processor }

    context "with airtable source" do
      let!(:agreement) do
        agreement = build(:agreement)
        agreement.fields["processors"] = [processor.record_id]
        agreement.save!
        agreement
      end

      before do
        allow(Rails.configuration).to receive(:data_source).and_return(:airtable)
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

    context "with rAPId source" do
      let!(:agreement) { create :agreement }

      let(:data) do
        {
          SecureRandom.uuid => {
            id: agreement.fields["id"],
            processor_name: processor.name,
          },
        }
      end

      before do
        allow(Rails.configuration).to receive(:data_source).and_return(:rapid)
        expect(RapidApi).to receive(:output_for).with(described_class::RAPID_TABLE_NAME).and_return(data)
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
    end
  end
end
