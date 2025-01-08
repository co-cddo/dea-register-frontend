require "rails_helper"

RSpec.describe ControlPerson, type: :model do
  it_behaves_like "is_data_table"

  describe ".populate" do # Note that most populate behavior is tested in the shared example 'is_data_table'
    subject(:populate) { described_class.populate }

    context "with rAPId source" do
      let(:controller_name) { Faker::Name.name }
      let(:data) do
        {
          1 => {
            controller_name:,
            foo: "bar",
          },
          2 => {
            controller_name:,
            foo: "xxx",
          },
        }
      end

      before do
        expect(RapidApi).to receive(:output_for).with(described_class.rapid_table_name).and_return(data)
      end

      it "assumes name is unique and does not create duplicates" do
        expect { populate }.to change(described_class, :count).by(1)
      end

      it "saves controller name to name" do
        populate
        expect(described_class.last.name).to eq(controller_name)
      end
    end
  end
end
