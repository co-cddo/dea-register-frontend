require "rails_helper"

RSpec.describe AgreementProcessor, type: :model do
  describe ".populate" do
    subject(:populate) { described_class.populate }

    let!(:processor) { create :processor }

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
