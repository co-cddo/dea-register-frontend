require "rails_helper"

RSpec.describe SourceRecordCleaner, type: :service do
  describe ".clean" do
    subject(:clean) do
      # Record is updated in processing, so:
      #   passing in a copy of record so that we can compare with original after processing
      described_class.clean(record.dup)
    end
    let(:name) { Faker::Name.name }
    let(:id) { rand(0..100).to_s }
    let(:valid_date) { Faker::Date.in_date_period.to_s }

    let(:record) do
      {
        id:,
        name:,
        start_date: valid_date,
        end_date: valid_date,
        review_date: valid_date,
      }
    end

    it "does nothing to valid records" do
      expect(clean).to eq(record)
    end

    context "with invalid dates" do
      let(:record) do
        {
          id:,
          name: "invalid",
          start_date: "invalid",
          end_date: "invalid",
          review_date: "invalid",
        }
      end

      it "modifies the record" do
        expect(clean).not_to eq(record)
      end

      it "replaces invalid dates with nil" do
        expect(clean[:start_date]).to be_nil
        expect(clean[:end_date]).to be_nil
        expect(clean[:review_date]).to be_nil
      end

      it "does not change non-date fields" do
        expect(clean[:name]).to eq("invalid")
      end
    end
  end
end
