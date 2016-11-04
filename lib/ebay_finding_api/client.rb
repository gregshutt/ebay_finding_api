require 'faraday'

require 'active_collab/client/account'
require 'active_collab/client/users'
require 'active_collab/response/parse_json'
require 'active_collab/response/raise_error'

module EbayFindingApi
  class Client

    attr_reader :app_id

    attr_accessor :api_endpoint
    attr_accessor :user_agent
    attr_accessor :middleware

    # see http://developer.ebay.com/devzone/finding/concepts/findingapiguide.html#work
    API_VERSION = 1
    API_ENDPOINT_PRODUCTION = 'http://svcs.ebay.com/services/search/FindingService/v1'
    API_ENDPOINT_SANDBOX = 'http://svcs.sandbox.ebay.com/services/search/FindingService/v1'

    def initialize(hostname = nil, username = nil, password = nil)
      @api_url = hostname

      if (! username.nil?) && (! password.nil?)
        sign_in(username, password)
      end
    end

    def api_url
      @api_url ||= API_URL_DEFAULT
    end

    def user_agent
      @user_agent ||= "ActiveCollab #{ActiveCollab::VERSION.to_s}"
    end

    def middleware
      @middleware ||= Faraday::RackBuilder.new do |builder|
        builder.use Faraday::Request::UrlEncoded
        builder.use ActiveCollab::Response::RaiseError
        builder.use ActiveCollab::Response::ParseJSON
        builder.adapter Faraday.default_adapter
      end
    end

    private
      def get(path, params = {})
        request(:get, build_url(path), params, connection)
      end

      def post(path, params = {})
        request(:post, build_url(path), params, connection)
      end

      def request(method, path, parameters = {}, request_connection)
        if signed_in?
          request = proc do |request|
            request.headers['X-Angie-AuthApiToken'] = @token
          end

          request_connection.send(method.to_sym, path, parameters, &request).env
        else
          request_connection.send(method.to_sym, path, parameters).env
        end
      rescue Faraday::Error::ClientError
        raise 'oh noes'
      end
    
      def connection
        @connection ||= connection_with_url(api_url)
      end

      def connection_with_url(url)
        Faraday.new url, builder: middleware
      end

      def build_url(path)
        "/api/v#{API_VERSION}#{path}"
      end
  end
end