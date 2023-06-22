require "rails_helper"

RSpec.describe "Agreements", type: :request do
  let(:fields) { { "Purpose" => Faker::Lorem.sentence } }
  let!(:agreement) { create :agreement, fields: }

  describe "GET root (index)" do
    let!(:other) { create :agreement }

    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "displays link to agreement" do
      get root_path
      expect(response.body).to include(agreement_path(agreement))
    end

    it "displays link to other agreement" do
      get root_path
      expect(response.body).to include(agreement_path(other))
    end
  end

  describe "GET /agreements/:id show" do
    it "returns http success" do
      get agreement_path(agreement)
      expect(response).to have_http_status(:success)
    end

    it "displays agreement fields" do
      get agreement_path(agreement)
      expect(response.body).to include(fields["Purpose"])
    end
  end
end
