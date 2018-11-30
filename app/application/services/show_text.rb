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
				if input.empty?
					Failure('Nothing pass to this page')
				else
					article_encoded = input.encode('UTF-8', invalid: :replace, undef: :replace)
					article_unescaped = URI.unescape(article_encoded).to_s
					Success(text: article_unescaped)
				end
			end
			
			def find_text(input)
				text = text_in_database(input)
        Success(text)
      rescue StandardError => error
        Failure('Having trouble accessing the database')
			end
			
			def text_in_database(input)
        Repository::For.klass(Entity::Text).find_text(input[:text])
      end
			
    end
	end
end