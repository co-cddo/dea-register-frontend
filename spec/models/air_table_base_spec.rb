require "rails_helper"

RSpec.describe AirTableBase, type: :model do
  let(:base) do
    {
      id: SecureRandom.uuid,
      name: Faker::Company.name,
      permissionLevel: Faker::Lorem.word,
    }
  end
  let(:data) do
    { bases: [base] }
  end

  describe ".populate" do
    subject(:populate) { described_class.populate }

    before do
      expect(AirTableApi).to receive(:data_for).and_return(data)
    end

    it "creates a new record" do
      expect { populate }.to change(described_class, :count).by(1)
    end

    it "populates the record" do
      populate
      record = described_class.last
      expect(record.name).to eq(base[:name])
      expect(record.base_id).to eq(base[:id])
      expect(record.permission_level).to eq(base[:permissionLevel])
    end

    context "with an existing matching base" do
      let!(:air_table_base) { create :air_table_base, base_id: base[:id] }

      it "does not create a new record" do
        expect { populate }.not_to change(described_class, :count)
      end

      it "does update the record" do
        populate
        air_table_base.reload
        expect(air_table_base.name).to eq(base[:name])
        expect(air_table_base.permission_level).to eq(base[:permissionLevel])
      end
    end
  end

  describe ".default" do
    subject(:default) { described_class.default }

    before do
      allow(AirTableApi).to receive(:data_for).and_return(data)

      # clear cached entry
      if described_class.instance_variable_defined?(:@default)
        described_class.remove_instance_variable(:@default)
      end
    end

    it "returns a new air table base" do
      expect(default.base_id).to eq(base[:id])
    end

    it "caches the new entry" do
      default
      expect(described_class.instance_variable_get(:@default).base_id).to eq(base[:id])
    end

    context "with an existing air table base" do
      let!(:air_table_base) { create :air_table_base }

      it "uses the existing record" do
        expect(default.base_id).to eq(air_table_base.base_id)
      end
    end
  end
end
