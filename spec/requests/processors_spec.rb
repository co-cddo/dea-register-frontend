require "rails_helper"

RSpec.describe "/processors", type: :request do
  let!(:processor) { create :processor }

  describe "GET /processors" do
    it "renders a successful response" do
      get processors_path
      expect(response).to have_http_status(:success)
    end

    it "displays link to processor" do
      get processors_path
      expect(response.body).to include(processor_path(processor))
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get processor_path(processor)
      expect(response).to have_http_status(:success)
    end

    it "displays processor name" do
      get processor_path(processor)
      expect(response.body).to include(processor.name)
    end
  end
end
