class AirTableApi
  API_KEY = ENV.fetch("AIRTABLE_API_KEY", Rails.application.credentials.airtable_api_key).freeze
  BASE_URL = "https://api.airtable.com/v0".freeze

  RequestError = Class.new(StandardError)

  require "net/http"

  def self.data_for(path, query: {})
    new(path, query:).output
  end

  def initialize(path, query: {})
    @path = path
    @query = query
  end

  def output
    return data if data[:error].blank?

    raise RequestError, "GET #{uri} returns error: #{data[:error]}"
  end

private

  attr_reader :path, :query

  def data
    @data ||= JSON.parse(response, symbolize_names: true)
  end

  def response
    uri.query = query.to_param if query.present?
    Net::HTTP.get(uri, headers)
  end

  def uri
    @uri ||= URI(File.join(BASE_URL, path))
  end

  def headers
    { Authorization: "Bearer #{API_KEY}" }
  end
end
