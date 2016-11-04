require 'faraday'

require 'ebay_finding_api/client/completed_items'

module EbayFindingApi
  class Client
    include EbayFindingApi::Client::CompletedItems

    attr_reader :app_id

    attr_accessor :api_endpoint
    attr_accessor :user_agent
    attr_accessor :middleware

    # see http://developer.ebay.com/devzone/finding/concepts/findingapiguide.html#work
    API_VERSION = "1.0.0"
    API_ENDPOINT_PRODUCTION = 'http://svcs.ebay.com/services/search/FindingService/v1'
    API_ENDPOINT_SANDBOX = 'http://svcs.sandbox.ebay.com/services/search/FindingService/v1'

    def initialize(app_id, sandbox_mode = false)
      @app_id = app_id
      @sandbox_mode = sandbox_mode
    end

    def api_url
      if @sandbox_mode
        API_ENDPOINT_SANDBOX
      else
        API_ENDPOINT_PRODUCTION
      end
    end

    def user_agent
      @user_agent ||= "EbayFindingApiClient #{EbayFindingApi::VERSION.to_s}"
    end

    def middleware
      @middleware ||= Faraday::RackBuilder.new do |builder|
        builder.use Faraday::Request::UrlEncoded
        #builder.use ActiveCollab::Response::RaiseError
        #builder.use ActiveCollab::Response::ParseJSON
        builder.adapter Faraday.default_adapter
      end
    end

    private
      def get(operation, params = {})
        request(:get, operation, params, connection)
      end

      def post(operation, params = {})
        request(:post, operation, params, connection)
      end

      def request(method, operation, parameters = {}, request_connection)
        request = proc do |request|
          request.headers['X-EBAY-SOA-SERVICE-VERSION'] = API_VERSION
          request.headers['X-EBAY-SOA-SECURITY-APPNAME'] = @app_id
          request.headers['X-EBAY-SOA-REQUEST-DATA-FORMAT'] = 'NV'
          request.headers['X-EBAY-SOA-RESPONSE-DATA-FORMAT'] = 'JSON'
          request.headers['X-EBAY-SOA-OPERATION-NAME'] = operation
        end

        request_connection.send(method.to_sym, api_url, parameters, &request).env
      rescue Faraday::Error::ClientError
        raise 'oh noes'
      end
    
      def connection
        @connection ||= connection_with_url(api_url)
      end

      def connection_with_url(url)
        Faraday.new url, builder: middleware
      end
  end
end