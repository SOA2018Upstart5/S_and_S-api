# frozen_string_literal: true

require 'base64'
require 'dry/monads/result'
require 'json'

module SeoAssistant
  module Value
    # List request parser
    class ArticlesRequest
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming article requests
      def call
        articles = JSON.parse(Base64.urlsafe_decode64(@params['articles']))
        Success(articles)
      rescue StandardError
        Failure(Value::Result.new(status: :bad_request, message: 'Article list not found'))
      end

      # Use in client App to create params to send
      def self.to_encoded(articles)
        Base64.urlsafe_encode64(list.to_json)
      end

      # Use in tests to create a ListRequest object from a list
      def self.to_request(articles)
        ArticlesRequest.new('articles' => to_encoded(articles))
      end
    end
  end
end
