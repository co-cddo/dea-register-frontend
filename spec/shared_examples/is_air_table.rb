shared_examples_for "is_air_table" do
  # make sure a base exists to avoid callout for base
  let!(:air_table_base) { create :air_table_base }
  let(:base_id) { AirTableBase.base_id }

  # There needs to be an air table table object to look up the table id
  let!(:air_table_table) { create :air_table_table, name: described_class.air_table_name }
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

    context "when record is empty" do
      let(:fields) { {} }

      it "does not create a record" do
        expect { populate }.not_to change(described_class, :count)
      end
    end

    context "when record has draft sync status" do
      let(:fields) do
        {
          name:,
          foo: "bar",
          Sync_Status: "Draft",
        }
      end

      it "does not create a record" do
        expect { populate }.not_to change(described_class, :count)
      end
    end

    context "when name has two parts separated by a colon" do
      let(:first_part) { Faker::Lorem.sentence }
      let(:second_part) { Faker::Company.name }
      let(:name) { "#{first_part} : #{second_part}" }

      it "creates a new record" do
        expect { populate }.to change(described_class, :count).by(1)
      end

      it "only uses the second part to populate the name attribute" do
        populate
        record = described_class.last
        expect(record.name).to eq(second_part)
      end
    end

    context "when name has three parts separated by colons" do
      let(:first_part) { Faker::Lorem.sentence }
      let(:second_part) { Faker::Company.name }
      let(:third_part) { Faker::Lorem.sentence }
      let(:name) { "#{first_part} : #{second_part} : #{third_part} " }

      it "creates a new record" do
        expect { populate }.to change(described_class, :count).by(1)
      end

      it "Uses the name as it is but strips off leading/trailing spaces" do
        populate
        record = described_class.last
        expect(record.name).to eq(name.strip)
      end
    end

    context "when records are removed from Airtable" do
      # In this condition the records will be in the local database but not in the
      # data pulled from air table
      before { create_list described_class.to_s.underscore.to_sym, 2 }

      it "creates a new record" do
        expect { populate }.to change(described_class, :count).by(-1)
      end
    end
  end
end
