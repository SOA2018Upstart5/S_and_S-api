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
			
			# input => input[:article] = article
			def decode_article(input)
				article_encoded = input[:article].encode('UTF-8', invalid: :replace, undef: :replace)
        article_unescaped = URI.unescape(article_encoded).to_s
				if article_unescaped.empty?
					Failure(Value::Result.new(status: :no_content, message: 'Nothing pass to this page'))
				else
					Success(article_unescaped)
				end
			end
			
			def find_text(input)
				text_entity = text_in_database(input)
				puts "show_text: find_text input = " + input
				#puts text_entity.text
        Success(Value::Result.new(status: :ok, message: text_entity))
			rescue StandardError => error
				puts "show_text: find_text fail"
				Failure(Value::Result.new(status: :not_found, message: 'Having trouble accessing the database'))
			end
			
			def text_in_database(input)
				puts "show_text: text_in_database" + input
				Repository::For.klass(Entity::Text).find_text(input)
      end
			
    end
	end
end