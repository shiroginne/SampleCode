require 'restclient'
require 'digest'

API_KEY = "put your api key here"
SHARED_SECRET = "put your shared secret here"
BASE_URL = "https://sandbox.api.visa.com/wallet-services-web/"
GET_URL = "payment/data/"

def get_payment_data(call_id)
  resource_path = "GET_URL#{call_id}"
  query_string = "apiKey=#{API_KEY}&dataLevel=FULL"
  request_body = ""

  xpay_token = get_xpay_token(resource_path, query_string, request_body)
  full_request_url = "#{BASE_URL}#{RESOURCE_PATH}?#{QUERY_STRING}"

  puts "Making Get Payment Data at #{full_request_url}"

  begin
    RestClient::Request.execute(
      :url => full_request_url,
      :method => :get,
      :headers => {
        "accept" => "application/json" ,
        "content-type" => "application/json",
        'x-pay-token' => xpay_token
      }
    )
  rescue RestClient::ExceptionWithResponse => e
    e.response
  end
end

def get_xpay_token(resource_path, query_string, request_body)
  timestamp = Time.now.utc.to_i
  hash_input = "#{SHARED_SECRET}#{timestamp}#{resource_path}#{query_string}#{request_body}"
  hash_output = Digest::SHA256.hexdigest(hash_input)

  "x:#{timestamp}:#{hash_output}"
end


puts get_payment_data("put your call id here")
