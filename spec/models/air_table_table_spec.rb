require "rails_helper"

RSpec.describe AirTableTable, type: :model do
  let(:table) do
    {
      id: SecureRandom.uuid,
      name: Faker::Company.name,
    }
  end
  let(:data) do
    { tables: [table] }
  end

  describe ".populate" do
    subject(:populate) { described_class.populate }

    before do
      create :air_table_base
      expect(AirTableApi).to receive(:data_for).and_return(data)
    end

    it "creates a new record" do
      expect { populate }.to change(described_class, :count).by(1)
    end

    it "populates the record" do
      populate
      record = described_class.last
      expect(record.name).to eq(table[:name])
      expect(record.record_id).to eq(table[:id])
    end
  end

  describe ".id_for_name" do
    let(:table_record) { create :air_table_table }

    it "returns the id when passed a table name" do
      expect(described_class.id_for_name(table_record.name)).to eq(table_record.record_id)
    end

    context "when table not populated" do
      before do
        described_class.delete_all
        create :air_table_base
        expect(AirTableApi).to receive(:data_for).and_return(data)
      end
      it "populates the table and finds the id" do
        expect(described_class.id_for_name(table[:name])).to eq(table[:id])
      end
    end
  end
end
