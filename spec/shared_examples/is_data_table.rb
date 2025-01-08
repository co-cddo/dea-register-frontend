shared_examples_for "is_data_table" do
  describe ".populate" do
    subject(:populate) { described_class.populate }

    let(:name) { Faker::Name.name }
    let(:id) { rand(0..100).to_s }

    context "with rAPId source" do
      let(:fields) do
        {
          id:,
          described_class.rapid_name_field => name,
          foo: "bar",
        }
      end
      let(:data) do
        {
          id => fields,
        }
      end

      before do
        expect(RapidApi).to receive(:output_for).with(described_class.rapid_table_name).and_return(data)
      end

      it "creates a new record" do
        expect { populate }.to change(described_class, :count).by(1)
      end

      it "populates the record" do
        populate
        record = described_class.last
        expect(record.name).to eq(name)
        expect(record.record_id).to eq(id)
        expect(record.fields["foo"]).to eq("bar")
      end

      context "when contained dates are invalid" do
        let(:data) do
          {
            id => {
              id:,
              described_class.rapid_name_field => name,
              end_date: "invalid",
            },
          }
        end

        it "replaces invalid with null" do
          populate
          record = described_class.last
          expect(record.fields["end_date"]).to be_nil
        end
      end

      context "when contained dates are valid" do
        let(:valid_date) { Faker::Date.in_date_period.to_s }
        let(:data) do
          {
            id => {
              id:,
              described_class.rapid_name_field => name,
              end_date: valid_date,
            },
          }
        end

        it "does not alter date entry" do
          populate
          record = described_class.last
          expect(record.fields["end_date"]).to eq(valid_date)
        end
      end

      context "when keys are not downcase" do
        let(:fields) do
          {
            id:,
            described_class.rapid_name_field => name,
            Foo_Bar: "bar",
          }
        end

        it "saves the fields with downcase keys" do
          populate
          record = described_class.last
          expect(record.fields["foo_bar"]).to eq("bar")
        end
      end

      context "when keys contain spaces" do
        let(:fields) do
          {
            id:,
            described_class.rapid_name_field => name,
            "Foo Bar": "bar",
          }
        end

        it "saves the fields with downcase keys" do
          populate
          record = described_class.last
          expect(record.fields["foo_bar"]).to eq("bar")
        end
      end

      context "when record is empty" do
        let(:fields) { {} }

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
end
