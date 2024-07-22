class RapidApi
  RAPID_URL = "https://upload-cddo.data.gov.uk".freeze
  RAPID = {
    client_id: ENV.fetch("RAPID_CLIENT_ID", Rails.application.credentials.rapid[:client_id]),
    client_name: ENV.fetch("RAPID_CLIENT_NAME", Rails.application.credentials.rapid[:client_name]),
    client_secret: ENV.fetch("RAPID_CLIENT_SECRET", Rails.application.credentials.rapid[:client_secret]),
  }.freeze

  RequestError = Class.new(StandardError)

  def access_token
    @access_token ||= begin
      response = auth_conn.post("/api/oauth2/token") do |req|
        req.body = {
          grant_type: "client_credentials",
          client_id: RAPID[:client_id],
        }.to_json
      end
      json = JSON.parse(response.body, symbolize_names: true)

      raise(RequestError, "Authentication failed: #{json[:error]}") if json[:error].present?

      json[:access_token]
    end
  end

  def output_for(dataset)
    response = data_conn.post("/api/datasets/transformed_dev/cddo_dea_register/#{dataset}/query")

    json = JSON.parse(response.body, symbolize_names: true)

    return json if response.success?

    raise(RequestError, "Output failed: #{json[:details]}")
  end

private

  def auth_conn
    Faraday.new(
      url: RAPID_URL,
      headers: { "Content-Type" => "application/x-www-form-urlencoded" },
    ) do |conn|
      conn.request :authorization, :basic, RAPID[:client_id], RAPID[:client_secret]
    end
  end

  def data_conn
    Faraday.new(
      url: "https://upload-cddo.data.gov.uk",
      headers: { "Content-Type" => "application/x-www-form-urlencoded" },
    ) do |conn|
      conn.request :authorization, "Bearer", access_token
    end
  end
end
