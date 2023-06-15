require "rails_helper"

RSpec.describe "Agreements", type: :request do
  let(:fields) { { foo: :bar } }
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

    context "with search request" do
      # make sure a base exists to avoid callout for base
      let(:air_table_base) { create :air_table_base }
      let(:base_id) { AirTableBase.base_id }

      # There needs to be an air table table object to look up the table id
      let(:air_table_table) { create :air_table_table, name: Agreement.air_table_name }
      let(:table_id) { air_table_table.record_id }

      let(:data) do
        { records: [{ id: agreement.record_id }] }
      end

      let(:query) do
        { "filterByFormula" => "SEARCH(\"#{agreement.name}\",{Name})" }
      end

      before do
        expect(AirTableApi).to receive(:data_for).with("#{base_id}/#{table_id}", query:).and_return(data)
      end

      it "returns http success" do
        get root_path, params: { q: agreement.name }
        expect(response).to have_http_status(:success)
      end

      it "displays link to agreement" do
        get root_path, params: { q: agreement.name }
        expect(response.body).to include(agreement_path(agreement))
      end

      it "does not displays link to other agreement" do
        get root_path, params: { q: agreement.name }
        expect(response.body).not_to include(agreement_path(other))
      end
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
