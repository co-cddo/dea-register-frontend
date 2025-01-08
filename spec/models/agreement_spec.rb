require "rails_helper"

RSpec.describe Agreement, type: :model do
  it_behaves_like "is_data_table"

  describe ".populate" do # Note that most populate behavior is tested in the shared example 'is_data_table'
    subject(:populate) { described_class.populate }

    before do
      expect(RapidApi).to receive(:output_for).with(described_class.rapid_table_name).and_return(data)
    end

    context "with duplicate ids" do
      let(:id) { rand(0..1).to_s }
      let(:data) do
        {
          1 => {
            id:,
            agreement_name: "Foo",
            foo: "yyy",
          },
          2 => {
            id:,
            agreement_name: "Bar",
            foo: "xxx",
          },
        }
      end

      it "assumes id is unique and does not create duplicates" do
        expect { populate }.to change(described_class, :count).by(1)
      end

      it "saves agreement name of last entry to name" do
        populate
        expect(described_class.last.name).to eq("Bar")
      end
    end

    context "with dates" do
      let(:data) do
        {
          1 => {
            id: 1,
            agreement_name: "Foo",
            start_date: 3.days.ago.strftime("%Y-%m-%d"),

          },
          2 => {
            id: 2,
            agreement_name: "Bar",
            start_date: 3.days.ago.strftime("%Y-%m-%d"),
            end_date: 2.days.ago.strftime("%Y-%m-%d"),

          },
          3 => {
            id: 3,
            agreement_name: "Other",
            start_date: 3.days.ago.strftime("%Y-%m-%d"),
            end_date: 2.days.from_now.strftime("%Y-%m-%d"),
          },
        }
      end

      it "sets status to active if no end date" do
        populate
        agreement = described_class.find_by_id!(1)
        expect(agreement.fields["isa_status"]).to eq("Active")
      end

      it "sets status to active if end date in past" do
        populate
        agreement = described_class.find_by_id!(2)
        expect(agreement.fields["isa_status"]).to eq("Complete")
      end

      it "sets status to active if end date in future" do
        populate
        agreement = described_class.find_by_id!(3)
        expect(agreement.fields["isa_status"]).to eq("Active")
      end
    end
  end

  describe "#id_and_name" do
    let(:agreement) { create :agreement, name: "Foo", fields: { id: "5" } }

    it "returns the ID and name of the agreement" do
      expect(agreement.id_and_name).to eq("5 - Foo")
    end

    context "when id missing" do
      let(:agreement) { create :agreement, fields: {} }
      it "just returns the name" do
        expect(agreement.id_and_name).to eq(agreement.name)
      end
    end
  end

  describe ".isa_statuses" do
    subject(:isa_statuses) { described_class.isa_statuses }
    let!(:others) { create_list :agreement, 2, fields: { isa_status: "foo" } }
    let!(:agreement) { create :agreement, fields: { isa_status: "bar" } }

    it "returns the existing ISA statuses" do
      expect(isa_statuses.size).to eq(2)
      expect(isa_statuses).to include(agreement.fields["isa_status"])
      expect(isa_statuses).to include(others.first.fields["isa_status"])
    end
  end
end
