require "rails_helper"

RSpec.describe Agreement, type: :model do
  it_behaves_like "is_air_table"

  # make sure a base exists to avoid callout for base
  let!(:air_table_base) { create :air_table_base }
  let(:base_id) { AirTableBase.base_id }

  # There needs to be an air table table object to look up the table id
  let!(:air_table_table) { create :air_table_table, name: described_class.air_table_name }
  let(:table_id) { air_table_table.record_id }

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

  describe "#id_and_name" do
    let(:agreement) { create :agreement, name: "Foo", fields: { ID: "5" } }

    it "returns the ID and name of the agreement" do
      expect(agreement.id_and_name).to eq("5 - Foo")
    end

    context "when id missing" do
      let(:agreement) { create :agreement }
      it "just returns the name" do
        expect(agreement.id_and_name).to eq(agreement.name)
      end
    end
  end
end
