require "rails_helper"

RSpec.describe "Agreements", type: :request do
  let(:fields) { { foo: :bar } }
  let!(:agreement) { create :agreement, fields: }

  describe "GET root (index)" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end

    it "displays link to agreement" do
      get root_path
      expect(response.body).to include(agreement_path(agreement))
    end
  end

  describe "GET /agreements/:id show" do
    it "returns http success" do
      get agreement_path(agreement)
      expect(response).to have_http_status(:success)
    end

    it "displays agreement fields" do
      get agreement_path(agreement)
      expect(response.body).to include("Foo")
      expect(response.body).to include("bar")
    end
  end
end
