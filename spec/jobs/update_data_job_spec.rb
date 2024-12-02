require "rails_helper"

RSpec.describe UpdateDataJob, type: :job do
  include ActiveJob::TestHelper

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe "#perform" do
    it "calls update data from source process" do
      expect { described_class.perform_later }.to have_enqueued_job

      expect(UpdateDataFromSource).to receive(:call).and_return(true)

      perform_enqueued_jobs
    end
  end
end
