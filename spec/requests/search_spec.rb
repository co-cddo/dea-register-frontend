require "rails_helper"

RSpec.describe "Searches", type: :request do
  describe "GET /search" do
    it "redirects to root" do
      get search_index_path
      expect(response).to redirect_to(root_path)
    end

    context "with a search query" do
      let(:query) { "Foo bar" }
      let!(:record) { create :air_table, name: "Foo #{Faker::Company.industry} bar" }
      let!(:other) { create :air_table, name: "Something else" }

      it "returns http success" do
        get search_index_path, params: { q: query }
        expect(response).to have_http_status(:success)
      end

      it "includes a link to the matching record" do
        get search_index_path, params: { q: query }
        expect(response.body).to include(polymorphic_path(record))
      end

      it "does not include a link to the other record" do
        get search_index_path, params: { q: query }
        expect(response.body).not_to include(polymorphic_path(other))
      end
    end
  end
end
