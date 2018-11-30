# frozen_string_literal: true

require 'base64'
require 'dry/monads/result'
require 'json'

module SeoAssistant
  module Value
    # List request parser
    class ArticleRequest
      include Dry::Monads::Result::Mixin

      def initialize(params)
        @params = params
      end

      # Use in API to parse incoming article requests
      def call
        article = @params['article'].to_s
        Success(article)
      rescue StandardError
        Failure(Value::Result.new(status: :bad_request, message: 'Article not found'))
      end
    end
  end
end
