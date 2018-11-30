# frozen_string_literal: true

require 'dry/transaction'
require 'uri'
require 'json'

module SeoAssistant
  module Service
    # Analyzes contributions to a project
    class ShowText
      include Dry::Transaction

			step :validate_article
			step :decode_article
      step :find_text
			
			private
			def validate_article(input)
        article_request = input[:article_request].call
        if article_request.success?
          Success(input.merge(article: article_request.value!))
        else
          Failure(article_request.failure)
        end
			end
			
			def decode_article(input)
				if input[:article].empty?
					Failure('Nothing pass to this page')
				else
					#article_encoded = input.encode('UTF-8', invalid: :replace, undef: :replace)
					#article_unescaped = URI.unescape(article_encoded).to_s
					article_unescaped = input[:article].to_s
					Success(text: article_unescaped)
				end
			end
			
			def find_text(input)
				text = text_in_database(input)
        Success(text)
			rescue StandardError => error
				Failure(Value::Result.new(status: :internal_error, message: 'Having trouble accessing the database'))
			end
			
			def text_in_database(input)
        Repository::For.klass(Entity::Text).find_text(input[:text])
      end
			
    end
	end
end