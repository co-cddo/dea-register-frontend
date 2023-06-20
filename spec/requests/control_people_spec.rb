require "rails_helper"

RSpec.describe "/control_people", type: :request do
  let!(:control_person) { create :control_person }

  describe "GET /control_people index" do
    it "renders a successful response" do
      get control_people_path
      expect(response).to have_http_status(:success)
    end

    it "displays link to control person" do
      get control_people_path
      expect(response.body).to include(control_person_path(control_person))
    end
  end

  describe "GET /control_people/:id show" do
    it "renders a successful response" do
      get control_person_path(control_person)
      expect(response).to have_http_status(:success)
    end

    it "displays control person" do
      get control_person_path(control_person)
      expect(response.body).to include(control_person.name)
    end

    context "when power present" do
      let(:power_control_person) { create :power_control_person }
      let(:control_person) { power_control_person.control_person }
      let(:power) { power_control_person.power }

      it "renders a successful response" do
        get control_person_path(control_person)
        expect(response).to have_http_status(:success)
      end

      it "displays control person" do
        get control_person_path(control_person)
        expect(response.body).to include(control_person.name)
      end

      it "displays a link to the power" do
        get control_person_path(control_person)
        expect(response.body).to include(power_path(power))
      end
    end
  end
end
