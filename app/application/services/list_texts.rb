# frozen_string_literal: true

require 'dry/monads'

module SeoAssistant
  module Service
    # Retrieves array of all listed project entities
    class ListTexts
      include Dry::Transaction

      step :validate_list
      step :call

      private

      def validate_list(input)
        articles_request = input[:articles_request].call
        if articles_request.success?
          Success(input.merge(list: articles_request.value!))
        else
          Failure(article_request.failure)
        end
      end

      def call(input)
        Repository::For.klass(Entity::Text).find_texts(input[:list])
          .yield_self { |texts| Value::TextsList.new(texts) }
          .yield_self do |list|
            Success(Value::Result.new(status: :ok, message: list))
          end
        
      rescue StandardError
        Failure(Value::Result.new(status: :internal_error, message: 'Cannot access database'))
      end
    end
  end
end