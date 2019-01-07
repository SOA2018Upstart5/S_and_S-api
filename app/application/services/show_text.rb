# frozen_string_literal: true

require 'dry/transaction'
require 'uri'
require 'json'

module SeoAssistant
  module Service
    # Analyzes contributions to a project
    class ShowText
      include Dry::Transaction

			step :decode_article
      step :find_text

			private

			def decode_article(input)
				article_encoded = input[:article].encode('UTF-8', invalid: :replace, undef: :replace)
				article_unescaped = URI.unescape(article_encoded).to_s
				if article_unescaped.empty?
					Failure(Value::Result.new(status: :no_content, message: 'Nothing pass to this page'))
				else
					Success(text: article_unescaped)
				end
			end

			def text_in_database(input)
				Repository::For.klass(Entity::Text).find_text(input[:text])
			end

			def find_text(input)
				text_entity = text_in_database(input)

				if text_entity
					Success(Value::Result.new(status: :ok, message: text_entity))
				else
					Failure(Value::Result.new(status: :not_found, message: "Could not find: #{input[:text]}"))
				end
			rescue StandardError => error
				Failure(Value::Result.new(status: :internal_error, message: 'Having trouble accessing the database'))
			end

    end
	end
end