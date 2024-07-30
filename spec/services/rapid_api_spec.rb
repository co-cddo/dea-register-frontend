require "rails_helper"

RSpec.describe RapidApi, type: :service do
  subject(:rapid_api) { described_class.new }
  let(:auth_url) { "https://upload-cddo.data.gov.uk/api/oauth2/token" }
  let(:data_url) { "https://upload-cddo.data.gov.uk/api/datasets/transformed_dev/cddo_dea_register/#{dataset}/query" }
  let(:dataset) { "agreements" }
  let(:access_token) { SecureRandom.uuid }
  let(:auth_response) do
    { access_token: }.to_json
  end

  before do
    stub_request(:post, auth_url)
      .to_return(body: auth_response)
  end

  describe "#access_token" do
    it "retrieves the access token" do
      expect(rapid_api.access_token).to eq(access_token)
    end

    context "with error" do
      let(:error) { "Whoops" }
      let(:auth_response) do
        { error: }.to_json
      end

      it "raises an error" do
        expect { rapid_api.access_token }.to raise_error(
          described_class::RequestError, "Authentication failed: #{error}"
        )
      end
    end
  end

  describe "#output_for" do
    let(:data_response) do
      { foo: "bar" }
    end
    let(:status) { 200 }

    before do
      stub_request(:post, data_url)
        .with(headers: { "Authorization" => "Bearer #{access_token}" })
        .to_return(body: data_response.to_json, status:)
    end

    it "returns data" do
      expect(rapid_api.output_for(:agreements)).to eq(data_response)
    end

    context "with error" do
      let(:error) { "Whoops" }
      let(:data_response) do
        { details: error }
      end
      let(:status) { 404 }

      it "raises an error" do
        expect { rapid_api.output_for(:agreements) }.to raise_error(
          described_class::RequestError, "Output failed: #{error}"
        )
      end
    end

    context "with no content" do
      let(:data_response) { "" }
      let(:status) { 204 }

      it "raises an error" do
        expect { rapid_api.output_for(:agreements) }.to raise_error(
          described_class::RequestError, "Output failed: No content"
        )
      end
    end
  end
end
