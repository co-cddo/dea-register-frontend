require "rails_helper"

RSpec.describe "Metadata", type: :request do
  describe "GET /metadata/data.json" do
    it "renders a successful response" do
      get metadatum_path(:data, format: :json)
      expect(response).to have_http_status(:success)
    end

    it "renders json" do
      get metadatum_path(:data, format: :json)
      expect(response.content_type).to start_with("application/json")
    end
  end

  describe "GET /metadata/data-marketplace.json" do
    it "renders a successful response" do
      get metadatum_path("data-marketplace", format: :json)
      expect(response).to have_http_status(:success)
    end

    it "renders json" do
      get metadatum_path("data-marketplace", format: :json)
      expect(response.content_type).to start_with("application/json")
    end
  end
end
