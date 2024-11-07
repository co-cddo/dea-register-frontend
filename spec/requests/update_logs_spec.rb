require "rails_helper"

RSpec.describe "UpdateLogs", type: :request do
  describe "GET /index" do
    let!(:update_log) { create :update_log }

    it "displays log" do
      get update_logs_path
      expect(response.body).to include(escape_html(update_log.comment))
    end
  end
end
