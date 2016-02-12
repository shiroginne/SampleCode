require 'restclient'
require 'digest'

API_KEY = "put your api key here"
SHARED_SECRET = "put your shared secret here"
BASE_URL = "cybersource/"
RESOURCE_PATH = "payments/v1/authorizations"
QUERY_STRING = "apiKey=#{API_KEY}"

def get_xpay_token(resource_path, query_string, request_body)
  timestamp = Time.now.utc.to_i
  hash_input = "#{SHARED_SECRET}#{timestamp}#{resource_path}#{query_string}#{request_body}"
  hash_output = Digest::SHA256.hexdigest(hash_input)

  "x:#{timestamp}:#{hash_output}"
end

def authorize_credit_card(request_body)
  xpay_token = get_xpay_token(RESOURCE_PATH, QUERY_STRING, request_body)
  full_request_url = "https://sandbox.api.visa.com/#{BASE_URL}#{RESOURCE_PATH}?#{QUERY_STRING}"

  begin
    RestClient::Request.execute(
      :url => full_request_url,
      :method => :post,
      :payload => request_body,
      :headers => {
        "content-type" => "application/json",
        "x-pay-token" => xpay_token
      }
    )
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end
end

request_body = {
  "amount" => "0",
  "currency" => "USD",
  "payment" => {
    "cardNumber" => "4111111111111111",
    "cardExpirationMonth" => "10",
    "cardExpirationYear" =>  "2016"
  }
}.to_json

puts authorize_credit_card(request_body)
