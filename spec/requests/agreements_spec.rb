require "rails_helper"

RSpec.describe "Agreements", type: :request do
  let(:fields) { { "Purpose" => Faker::Lorem.sentence } }
  let!(:agreement) { create :agreement, name: "A", fields: fields.merge(ID: 2) }

  describe "GET root (index)" do
    let!(:agreement_b) { create :agreement, name: "B", fields: { ID: 1 } }
    let!(:agreement_c) { create :agreement, name: "C", fields: { ID: 3 } }

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
      expect(response.body).to include(agreement_path(agreement_b))
    end

    context "when sorting present" do
      let(:html) { Nokogiri::HTML(response.body) }

      it "sorts by name" do
        get root_path, params: { sort_by: :name, direction: :ascending }
        expect(html.css(".agreement-name a").map(&:inner_html)).to eq(%w[A B C])
      end

      it "sorts by name descending" do
        get root_path, params: { sort_by: :name, direction: :descending }
        expect(html.css(".agreement-name a").map(&:inner_html)).to eq(%w[C B A])
      end

      it "sorts by id" do
        get root_path, params: { sort_by: :id, direction: :ascending }
        expect(html.css(".agreement-name a").map(&:inner_html)).to eq(%w[B A C])
      end

      it "sorts by id descending" do
        get root_path, params: { sort_by: :id, direction: :descending }
        expect(html.css(".agreement-name a").map(&:inner_html)).to eq(%w[C A B])
      end

      it "defaults to sorting by id ascending" do
        get root_path
        expect(html.css(".agreement-name a").map(&:inner_html)).to eq(%w[B A C])
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
      expect(response.body).to include(fields["Purpose"])
    end
  end
end
