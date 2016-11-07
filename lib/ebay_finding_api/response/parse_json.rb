require 'faraday'
require 'multi_json'

module EbayFindingApi

  # Methods for handling responses from eBay.
  module Response
    class ParseJSON < Faraday::Response::Middleware

      # Turn the response body into a JSON object.
      def parse(body)
        MultiJson.load(body, :symbolize_keys => true) unless body.nil?
      rescue MultiJson::LoadError
        body
      end

      def on_complete(env)
        if respond_to?(:parse)
          unless bad_status_codes.include? env[:status]
            env[:body] = parse env[:body]
          end
        end
      end

      def bad_status_codes
        @status_codes ||= [204, 301, 302, 304]
      end

    end
  end
end