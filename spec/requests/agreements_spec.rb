require "rails_helper"

RSpec.describe "Agreements", type: :request do
  let(:fields) { { "purpose" => Faker::Lorem.sentence } }
  let!(:agreement) do
    create(
      :agreement,
      name: "A",
      fields: fields.merge(
        id: 2,
        start_date: to_json_date(6.days.ago),
        end_date: to_json_date(3.days.ago),
        isa_status: "Completed",
      ),
    )
  end

  describe "GET root (index)" do
    let!(:agreement_b) do
      create(
        :agreement,
        name: "B",
        fields: {
          id: 1,
          start_date: to_json_date(5.days.ago),
          end_date: to_json_date(1.day.ago),
          isa_status: "Completed",
        },
      )
    end
    let!(:agreement_c) do
      create(
        :agreement,
        name: "C",
        fields: {
          id: 3,
          start_date: to_json_date(4.days.ago),
          end_date: to_json_date(2.days.ago),
          isa_status: "Active",
        },
      )
    end

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

    context "with a first letter filter" do
      it "displays link to matching agreements" do
        get root_path, params: { first_letter: "B" }
        expect(response.body).to include(agreement_path(agreement_b))
      end

      it "does not display links to other agrements" do
        get root_path, params: { first_letter: "B" }
        expect(response.body).not_to include(agreement_path(agreement))
        expect(response.body).not_to include(agreement_path(agreement_c))
      end
    end

    context "with ISA status filter" do
      it "displays link to matching agreements" do
        get root_path, params: { isa_status: "Active" }
        expect(response.body).to include(agreement_path(agreement_c))
      end

      it "does not display links to other agrements" do
        get root_path, params: { isa_status: "Active" }
        expect(response.body).not_to include(agreement_path(agreement))
        expect(response.body).not_to include(agreement_path(agreement_b))
      end
    end

    context "with controller filter" do
      let(:agreement_control_person) { create :agreement_control_person, agreement: }
      let(:control_person) { agreement_control_person.control_person }

      it "displays link to matching agreements" do
        get root_path, params: { controller_filter: control_person.id }
        expect(response.body).to include(agreement_path(agreement))
      end

      it "does not display links to other agrements" do
        get root_path, params: { controller_filter: control_person.id }
        expect(response.body).not_to include(agreement_path(agreement_b))
        expect(response.body).not_to include(agreement_path(agreement_c))
      end
    end

    context "with power filter" do
      let(:power_agreement) { create :power_agreement, agreement: }
      let(:power) { power_agreement.power }

      it "displays link to matching agreements" do
        get root_path, params: { power_filter: power.id }
        expect(response.body).to include(agreement_path(agreement))
      end

      it "does not display links to other agrements" do
        get root_path, params: { power_filter: power.id }
        expect(response.body).not_to include(agreement_path(agreement_b))
        expect(response.body).not_to include(agreement_path(agreement_c))
      end
    end

    context "when sorting present" do
      let(:html) { Nokogiri::HTML(response.body) }

      it "sorts by end date" do
        get root_path, params: { sort_by: :end_date, direction: :ascending }
        expect(html.css(".agreement-name a").map(&:inner_html)).to eq(%w[A C B])
      end

      it "sorts by end date descending" do
        get root_path, params: { sort_by: :end_date, direction: :descending }
        expect(html.css(".agreement-name a").map(&:inner_html)).to eq(%w[B C A])
      end

      it "sorts by start date" do
        get root_path, params: { sort_by: :start_date, direction: :ascending }
        expect(html.css(".agreement-name a").map(&:inner_html)).to eq(%w[A B C])
      end

      it "sorts by start date descending" do
        get root_path, params: { sort_by: :start_date, direction: :descending }
        expect(html.css(".agreement-name a").map(&:inner_html)).to eq(%w[C B A])
      end
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
      expect(response.body).to include(escape_html(fields["purpose"]))
    end
  end

  let(:json) { JSON.parse(response.body) }

  describe "GET /agreements.json index" do
    it "returns http success" do
      get agreements_path(format: :json), as: :json
      expect(response).to have_http_status(:success)
    end

    it "has agreements root with a JSON object" do
      get agreements_path(format: :json), as: :json
      expect(json.keys).to include("agreements")
    end

    it "displays agreement name" do
      get agreements_path(format: :json), as: :json
      expect(response.body).to include(escape_html(agreement.name))
    end

    it "displays path to agreement json show page" do
      get agreements_path(format: :json), as: :json
      expect(response.body).to include(agreement_path(agreement, format: :json))
    end

    it "show no links when only one agreement" do
      get agreements_path(format: :json), as: :json
      expect(json.dig("links", "next")).to be_blank
      expect(json.dig("links", "previous")).to be_blank
    end

    context "when pages of data" do
      let!(:agreements) { create_list :agreement, 30 }
      it "display link to next page" do
        get agreements_path(format: :json), as: :json
        expect(json.dig("links", "next")).to include(agreements_path(format: :json, page: 2))
      end

      it "displays link to previous page after first page" do
        get agreements_path(format: :json, page: 2), as: :json
        expect(json.dig("links", "previous")).to include(agreements_path(format: :json))
      end
    end
  end

  describe "GET /agreements/:id.json show" do
    it "returns http success" do
      get agreement_path(agreement, format: :json), as: :json
      expect(response).to have_http_status(:success)
    end

    it "displays data in fields" do
      get agreement_path(agreement, format: :json), as: :json
      expect(json.dig("agreement", "data")).to eq(agreement.fields)
    end

    it "includes the index json view path" do
      get agreement_path(agreement, format: :json), as: :json
      expect(json.dig("agreement", "links", "index")).to include(agreements_path(format: :json))
    end
  end
end
