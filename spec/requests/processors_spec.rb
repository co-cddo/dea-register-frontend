require "rails_helper"

RSpec.describe "/processors", type: :request do
  let!(:processor) { create :processor, name: "A" }

  let(:first_letter) { ("B".."Z").to_a.sample }
  let!(:matching_processor) { create :processor, name: first_letter }

  describe "GET /processors" do
    it "renders a successful response" do
      get processors_path
      expect(response).to have_http_status(:success)
    end

    it "displays link to processor" do
      get processors_path
      expect(response.body).to include(processor_path(processor))
    end

    context "with a first letter filter" do
      it "displays link to matching processors" do
        get processors_path, params: { first_letter: }
        expect(response.body).to include(processor_path(matching_processor))
      end

      it "does not display links to other processors" do
        get processors_path, params: { first_letter: }
        expect(response.body).not_to include(processor_path(processor))
      end
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get processor_path(processor)
      expect(response).to have_http_status(:success)
    end

    it "displays processor name" do
      get processor_path(processor)
      expect(response.body).to include(escape_html(processor.name))
    end
  end
end
