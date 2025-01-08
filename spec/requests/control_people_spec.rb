require "rails_helper"

RSpec.describe "/control_people", type: :request do
  let!(:control_person) { create :control_person, name: "A" }

  let(:first_letter) { ("B".."Z").to_a.sample }
  let!(:matching_control_person) { create :control_person, name: first_letter }

  describe "GET /control_people index" do
    it "renders a successful response" do
      get control_people_path
      expect(response).to have_http_status(:success)
    end

    it "displays links to control people" do
      get control_people_path
      expect(response.body).to include(control_person_path(control_person))
      expect(response.body).to include(control_person_path(matching_control_person))
    end

    context "with a first letter filter" do
      it "displays link to matching control people" do
        get control_people_path, params: { first_letter: }
        expect(response.body).to include(control_person_path(matching_control_person))
      end

      it "does not display links to other control people" do
        get control_people_path, params: { first_letter: }
        expect(response.body).not_to include(control_person_path(control_person))
      end
    end
  end

  describe "GET /control_people/:id show" do
    it "renders a successful response" do
      get control_person_path(control_person)
      expect(response).to have_http_status(:success)
    end

    it "displays control person" do
      get control_person_path(control_person)
      expect(response.body).to include(escape_html(control_person.name))
    end
  end
end
