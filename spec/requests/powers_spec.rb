require "rails_helper"

RSpec.describe "Powers", type: :request do
  describe "GET /powers" do
    let!(:power) { create :power, name: "A" }

    let(:first_letter) { ("B".."Z").to_a.sample }
    let!(:matching_power) { create :power, name: first_letter }

    it "returns http success" do
      get powers_path
      expect(response).to have_http_status(:success)
    end

    it "displays link to power" do
      get powers_path
      expect(response.body).to include(power_path(power))
    end

    context "with a first letter filter" do
      it "displays link to matching powers" do
        get powers_path, params: { first_letter: }
        expect(response.body).to include(power_path(matching_power))
      end

      it "does not display links to other powers" do
        get powers_path, params: { first_letter: }
        expect(response.body).not_to include(power_path(power))
      end
    end
  end

  describe "GET /powers/:id" do
    let(:power_agreement) { create :power_agreement }
    let(:power) { power_agreement.power }
    let(:agreement) { power_agreement.agreement }

    it "returns http success" do
      get power_path(power)
      expect(response).to have_http_status(:success)
    end

    it "displays power" do
      get power_path(power)
      expect(response.body).to include(power.name)
    end

    it "displays link to associated agreement" do
      get power_path(power)
      expect(response.body).to include(agreement_path(agreement))
    end
  end
end
