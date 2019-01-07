# frozen_string_literal: true

require 'dry/transaction'

module SeoAssistant
  module Service
    class AddText
      include Dry::Transaction

      step :find_text
      step :store_text

      private

      DB_ERR_MSG = 'Having trobule accessing the database'
      API_NOT_FOUND_MSG = 'Could not access API'

      def find_text(input)
        article_encoded = input[:text].encode('UTF-8', invalid: :replace, undef: :replace)
        article_unescaped = URI.unescape(article_encoded).to_s
        input[:decode_text] = article_unescaped

        if (text = text_in_database(input))
          input[:local_text] = text
        else
          input[:remote_text] = text_from_api(input)
        end
        Success(input)
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found, message: error.to_s))
      end

      def store_text(input)
        text =
          if (new_text = input[:remote_text])
            Repository::For.entity(new_text).create(new_text)
          else
            input[:local_text]
          end
        Success(Value::Result.new(status: :created, message: text))
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(Value::Result.new(status: :internal_error, message: DB_ERR_MSG))
      end

      # following are support methods that other services could use
      def text_from_api(input)
        OutAPI::TextMapper
          .new(JSON.parse(Api.config.GOOGLE_CREDS), Api.config.UNSPLASH_ACCESS_KEY)
          .process(input[:decode_text])
      rescue StandardError
        raise API_NOT_FOUND_MSG
      end

      def text_in_database(input)
        Repository::For.klass(SeoAssistant::Entity::Text).find_text(input[:decode_text])
      end
    end
  end
end
