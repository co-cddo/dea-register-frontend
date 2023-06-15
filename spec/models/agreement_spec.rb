require "rails_helper"

RSpec.describe Agreement, type: :model do
  # make sure a base exists to avoid callout for base
  let!(:air_table_base) { create :air_table_base }
  let(:base_id) { AirTableBase.base_id }

  # There needs to be an air table table object to look up the table id
  let!(:air_table_table) { create :air_table_table, name: Agreement.air_table_name }
  let(:table_id) { air_table_table.record_id }

  describe ".populate" do
    subject(:populate) { described_class.populate }

    let(:name) { Faker::Name.name }
    let(:fields) do
      {
        name:,
        foo: "bar",
      }
    end
    let(:id) { SecureRandom.uuid }
    let(:data) do
      {
        records: [{
          id:,
          fields:,
        }],
      }
    end

    before do
      expect(AirTableApi).to receive(:data_for).with("#{base_id}/#{table_id}", query: {}).and_return(data)
    end

    it "creates a new record" do
      expect { populate }.to change(described_class, :count).by(1)
    end

    it "populates the record" do
      populate
      record = described_class.last
      expect(record.name).to eq(name)
      expect(record.record_id).to eq(id)
      expect(record.fields).to eq(fields.stringify_keys)
    end

    context "when an offset exists" do
      # Offset needs to be returned by first calls so is added to the initial data
      let(:offset) { SecureRandom.uuid }
      let(:data) { super().merge(offset:) }

      # A second call is then triggered and that needs to return a different set of data
      # As this is then the last set of data, it does not include an offset
      let(:offset_id) { SecureRandom.uuid }
      let(:offset_data) do
        {
          records: [{
            id: offset_id,
            fields:,
          }],
        }
      end
      before do
        expect(AirTableApi).to receive(:data_for).with("#{base_id}/#{table_id}", query: { offset: }).and_return(offset_data)
      end

      it "creates records from two calls" do
        expect { populate }.to change(described_class, :count).by(2)
      end

      it "creates record that match the data" do
        populate
        expect(described_class.pluck(:record_id)).to contain_exactly(id, offset_id)
      end
    end
  end

  describe ".search" do
    let!(:agreement) { create :agreement, name: "it is all foo bar" }
    let!(:other) { create :agreement, name: "something else" }
    let(:data) do
      { records: [{ id: agreement.record_id }] }
    end
    let(:query) do
      { "filterByFormula" => "SEARCH(\"foo\",{Name})" }
    end

    before do
      expect(AirTableApi).to receive(:data_for).with("#{base_id}/#{table_id}", query:).and_return(data)
    end

    it "returns records that match the query" do
      expect(described_class.search("foo")).to include(agreement)
    end

    it "does not return records that do not match the query" do
      expect(described_class.search("foo")).not_to include(other)
    end
  end
end
