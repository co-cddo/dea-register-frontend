require "rails_helper"

RSpec.describe DataTable, type: :model do
  describe ".populate" do
    # For behaviour in subclasses use shared example "is_data_table" in those class specs.

    it "raises an error" do
      expect { described_class.populate }.to raise_error("Cannot run on root class - DataTable")
    end
  end
end
