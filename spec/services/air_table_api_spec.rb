require "rails_helper"

RSpec.describe AirTableApi, type: :service do
  describe ".data_for" do
    let(:path) { "/meta/bases" }
    let(:url) { File.join("https://api.airtable.com/v0", path) }
    let(:payload) do
      { foo: "bar" }
    end

    before do
      stub_request(:get, url)
        .with(headers: { "Authorization" => ["Bearer", described_class::API_KEY].select(&:present?).join(" ") })
        .to_return(body: payload.to_json)
    end

    it "returns payload from url response" do
      expect(described_class.data_for(path)).to eq(payload)
    end

    context "with query" do
      let(:query) do
        { some: "thing" }
      end
      let(:url) { File.join("https://api.airtable.com/v0", "#{path}?#{query.to_query}") }

      it "returns payload from url response" do
        expect(described_class.data_for(path, query:)).to eq(payload)
      end
    end

    context "with error" do
      let(:error) { Faker::Lorem.sentence }
      let(:payload) do
        { error: }
      end

      it "raises an error" do
        expect { described_class.data_for(path) }.to raise_error(AirTableApi::RequestError)
      end
    end
  end
end
