require "rails_helper"

RSpec.describe AirTable, type: :model do
  describe ".populate" do
    # For behaviour in subclasses use shared example "is_air_table" in those class specs.

    it "raises an error" do
      expect { described_class.populate }.to raise_error("Cannot run on root class - AirTable")
    end
  end
end
